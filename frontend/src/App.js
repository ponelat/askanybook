import {useCallback, useEffect, useRef} from 'react'
import ErrorPage from './ErrorPage'
import useHttp from './useHttp'
import QuestionInput from './QuestionInput'

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
    <div className="p-4 text-gray-800 bg-gray-50 dark:bg-gray-700" >
      <QuestionInput ref={inputRef} onAsk={askQuestion}/>
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
  );
}

export default App;
