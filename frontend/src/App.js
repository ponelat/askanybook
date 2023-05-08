import {useCallback, useEffect, useRef} from 'react'
import ErrorPage from './ErrorPage'
import useHttp from './useHttp'
import QuestionInput from './QuestionInput'
import Link from './Link'
import { SiGithub, SiTwitter } from 'react-icons/si'
import {BsCalendarDate} from 'react-icons/bs'
import { Typewriter } from 'react-simple-typewriter'

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

  // TODO: Move into storybook, so we can test each state without stubbing the controller manually
  // TODO: Add responsive size to img.
  return (
    <div className="p-4 container mx-auto text-gray-600 max-w-[700px]" >

      <div className="" >
	<img className="border shadow-lg mx-auto w-[170px] md:w-[300px]"  alt="The Minimalist Entrepeneur" src="/the-minimalist-entrepeneur.png"/>
      </div>

      <div className="mt-8" >

	<p className="text-left pl-4" >
	  Ask the book a question, and it will answer it...
	</p>

        <div className="mt-2" >
	  <QuestionInput ref={inputRef} onAsk={askQuestion}/>
        </div>

	<div className="py-3 px-4" >

	  {questionState.matches('loading') ? (
            <span>
	      <b>Answer:</b> Loading...
            </span>
	  ) : null}

	  {questionState.matches('error') ? (
	    <ErrorPage {...questionState.context} />
	  ) : null}

	  {questionState.matches('success') ? (
            <div>
              <div>
		<b>Asked:</b> {questionState.context.body.asked_count || '?'}
	      </div>
	      <div>
		<b>Answer:</b>

		<Typewriter
		  words={[questionState.context.body.answer]}
		  loop={1}
		  cursor
		  typeSpeed={30}
                  /* delaySpeed={30} */
		  deleteSpeed={false}
		/>

	      </div>

	    </div>
	  ) : null}
	</div>

      </div>


      <p className="text-center mt-12 text-gray-800" >
        <span className="" >
	  This is a reproduction of the experiment hosted at
        </span>
        <Link target="_blank" href="https://askmybook.com"> https://askmybook.com </Link>

	<div className="" >
	  <Link className="flex justify-center aligne-center opacity-70 hover:opacity-100"  href="https://github.com/ponelat/you-will-never-find-me-mwahaha-secret-project">
	    <div>
	      Source
	    </div>
	    <div>
	      <SiGithub className="w-6 h-6 relative ml-2 top-[-3px] text-gray-800 inline"   />
	    </div>
	  </Link>
	</div>
      </p>


      <div className="mt-3 text-gray-600 flex justify-center" >

	<div className="flex justify-center items-center" >
	  <div>
	    Project by <b> Josh Ponelat  </b>
	  </div>

	  <Link className="ml-2 opacity-70 hover:opacity-100"  href="https://twitter.com/jponelat">
	    <SiTwitter className="w-6 h-6 text-[#1DA1F2] opacity-50 hover:opacity-100" />
	  </Link>

	  <Link className="ml-2 opacity-70 hover:opacity-100"  href="https://calendly.com/ponelat/josh">
	    <BsCalendarDate className="w-6 h-6 relative top-[-1px] text-[#1DA1F2] opacity-50 hover:opacity-100" />
	  </Link>

	</div>

	
      </div>
    </div>
  );
}

export default App;
