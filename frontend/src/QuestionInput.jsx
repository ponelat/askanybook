import {useState, useCallback, forwardRef } from 'react'
import TextareaAutosize from 'react-textarea-autosize'

export default forwardRef(({ onAsk, isLoading=false }, ref) => {

  const [input, setInput] = useState('What is this book about? ')
  const onSubmit = useCallback(() => onAsk(input), [input, onAsk])

  // Shift enter to submit
  const handleKeyPress = useCallback((event) => {
    if(!input)
      return
    if (event.key === 'Enter' && !(event.shiftKey)) {
      event.preventDefault();
      onSubmit(input)
    }
  }, [input, onSubmit])

  return (
    
    <form onSubmit={e => { e.preventDefault(); console.log('hi'); onSubmit(input) }}>
      <label htmlFor="chat" className="sr-only">
	A question
      </label>
      <div className="flex flex-col w-full py-2 flex-grow md:py-3 md:pl-4 focus:ring-0 relative border border-black/10 bg-white dark:border-gray-900/50 dark:text-white dark:bg-gray-700 rounded-md shadow-[0_0_10px_rgba(0,0,0,0.10)] dark:shadow-[0_0_15px_rgba(0,0,0,0.10)]">
	<TextareaAutosize
          ref={ref}
	  id="chat"
          minRows={1}
          onKeyPress={handleKeyPress}
	  className="m-0 w-full resize-none border-0 bg-transparent p-0 pr-11 focus:ring-0 focus-visible:ring-0 outline-none dark:bg-transparent pl-2 md:pl-0"
          value={input}
          onChange={(e) => setInput(e.target.value)}
	  placeholder="Ask a question..."
	/>
	<button
	  type="submit"
          disabled={!input.length}
	  className="absolute p-1 rounded-md text-gray-500 bottom-1.5 md:bottom-2.5 hover:bg-gray-100 enabled:dark:hover:text-gray-400 dark:hover:bg-gray-900 disabled:hover:bg-transparent dark:disabled:hover:bg-transparent right-1 md:right-2 disabled:opacity-40"
	>
	  <svg
	    aria-hidden="true"
	    className="w-6 h-6 rotate-45"
	    fill="currentColor"
	    viewBox="0 0 20 20"
	    xmlns="http://www.w3.org/2000/svg"
	  >
	    <path d="M10.894 2.553a1 1 0 00-1.788 0l-7 14a1 1 0 001.169 1.409l5-1.429A1 1 0 009 15.571V11a1 1 0 112 0v4.571a1 1 0 00.725.962l5 1.428a1 1 0 001.17-1.408l-7-14z" />
	  </svg>
	  <span className="sr-only">Send message</span>
	</button>

      </div>
      <div className="text-gray-400 text-sm pt-0.5 text-center">Shift-Enter for newlines</div>
    </form>

  )
})

