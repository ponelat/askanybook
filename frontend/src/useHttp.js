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
	src: (context, event) => fetch2xx(event.url, event.fetchDetails),
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
      type: 'final'
    },
    error: {
      on: {
	RETRY: 'loading'
      }
    }
  }
}, {
  actions: {
    setResult: (context, event) => {
      context.body = event.data;
    },
    setError: (context, event) => {
      context.title = event.data.title || 'Error'
      context.detail = event.data.detail || 'Unknown'
      context.instance = event.data.instance || ''
    }
  }
});

const useFetch = (url, fetchDetails) => {
  const [state, send] = useMachine(fetchMachine);
  const fetchData = () => {
    send({ type: 'FETCH', url, fetchDetails });
  };

  return [state, fetchData];
};

export default useFetch;
