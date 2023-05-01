import {useCallback, useEffect, useRef} from 'react'
import ErrorPage from './ErrorPage'
import useHttp from './useHttp'
import QuestionInput from './QuestionInput'
import Link from './Link'

function App() {
  const inputRef = useRef(null)

  const [healthState, checkHealth] = useHttp('/health')

  const [questionState, fetchAnswer] = useHttp(question => ({
    url: '/ask',
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ question })
  }))

  // Prefer this function, over directly passing fetchAnswer to a component. So we know what props we're dealing with.
  const askQuestion = useCallback((question) => fetchAnswer(question), [fetchAnswer])

  useEffect(() => {
    checkHealth()
  }, [checkHealth])

  // Focus cursor at the _end_ of the question input
  useEffect(() => {
    if(inputRef.current) {
      inputRef.current.focus()
      const inputLength = inputRef.current.value.length
      inputRef.current.setSelectionRange(inputLength, inputLength);
    }
  }, [inputRef])


  // TODO: Move the health check into a router
  if(healthState.matches('error')) {
    return <ErrorPage {...healthState.context} unexpected="GET /health came back negative" />
  }

  return (
    <div className="p-4 container mx-auto text-gray-700 max-w-[700px]" >

      <div className="" >
	<img className="mx-auto w-[200px]"  alt="The Minimalist Entrepeneur" src="/the-minimalist-entrepeneur.png"/>
	<h2 className="text-gray-600 text-2xl font-bold text-center" >Ask me</h2>
      </div>

      <p className="text-center mt-6" >
        This is a reproduction of the experiment hosted at
        <Link target="_blank" href="https://askmybook.com"> https://askmybook.com </Link>
        <br/>
        TODO: Add Josh magic
      </p>

      <div className="mt-8" >

	<p className="text-left pl-4" >
	  Ask the book a question, and it will answer it...
	</p>

        <div className="mt-2" >
	  <QuestionInput ref={inputRef} onAsk={askQuestion}/>
        </div>

	<div className="py-3 px-4" >

	  {questionState.matches('loading') ? (
	    <span>Loading...</span>
	  ) : null}

	  {questionState.matches('error') ? (
	    <ErrorPage {...questionState.context} />
	  ) : null}

	  {questionState.matches('success') ? (
	    <div>
	      <b>Answer:</b> {questionState.context.body.answer}
	    </div>
	  ) : null}
	</div>

      </div>

      <div className="mt-8 text-center" >
	Project by <Link href="https://www.ponelat.com"> Josh Ponelat  </Link>
      </div>
    </div>
  );
}

export default App;
