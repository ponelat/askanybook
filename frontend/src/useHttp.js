import {useCallback} from 'react'
import { useMachine } from '@xstate/react';
import { Machine } from 'xstate';

// Simple wrapper around fetch, to throw on anything other than 2xx
// PS: Assumes json response, always.
const fetch2xx = (...args)  => fetch(...args).then(res => {
  if(res.ok) {
    return res.json()
  }
  return res.json().then(body => {
    // This should be problem+json
    throw body
  })
  
})

// States = idle, loading, error, success
// Events = FETCH, RETRY
const fetchMachine = Machine({
  id: 'fetch',
  initial: 'idle',
  states: {
    idle: {
      on: {
	FETCH: 'loading'
      }
    },
    loading: {
      invoke: {
	id: 'fetchData',
	src: (context, event) => fetch2xx(event.http.url, event.http),
	onDone: {
	  target: 'success',
	  actions: 'setResult'
	},
	onError: {
	  target: 'error',
	  actions: 'setError'
	}
      }
    },
    success: {
      on: {
	FETCH: 'loading'
      }
    },
    error: {
      on: {
	FETCH: 'loading'
      }
    }
  }
}, {
  actions: {
    setResult: (context, event) => {
      context.body = event.data;
    },
    setError: (context, event) => {

      // Also catches parser errors of the JSON
      if(Error.prototype.isPrototypeOf(event.data)) {
        context.title = event.data.name 
        context.detail = event.data.message
        return
      }

      context.title = event.data.title || 'Error'
      context.detail = event.data.detail || 'Unknown'
      context.instance = event.data.instance || ''
    }
  }
});

const useHttp = (httpLike) => {
  const [state, send, service] = useMachine(fetchMachine);
  const fetchData = useCallback(async (...args) => {
    let httpLikeObj 
    if(typeof httpLike === 'string') {
      httpLikeObj = { url: httpLike }
    }

    if(typeof httpLike == 'function') {
      httpLikeObj = await httpLike(...args)
    }

    if(typeof httpLikeObj !== 'object' || !httpLikeObj) {
      throw Error('Argument to useHttp does not resolve to an object')
    }

    send({ type: 'FETCH', http: httpLikeObj });
  }, [httpLike, send])

  return [state, fetchData, service];
};

export default useHttp;
