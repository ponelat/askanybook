import React from 'react'

// Example
// {
//   "title": "Internal Server Error",
//   "status": 500,
//   "detail": "undefined method `Exception' for #<AskController:0x00000000043da0>\n\n    raise Exception('what happens?')\n          ^^^^^^^^^"
// }

export default function ErrorPage({unexpected, title, status, detail}) {
  return (
    <div className="m-4 p-4 bg-red-50 text-red-700 border border-red-200" >
      <h2 className="text-2xl" >
	<b>Error:</b> {title}
      </h2>

      <div className="text-red-500" >
        {unexpected && (
	  <h3 className="mt-2" >{unexpected}</h3>
        )}
        <hr className="my-2 border-red-200" />
        <code>
          {detail}
        </code>
      </div>
    </div>
  )
  
}
