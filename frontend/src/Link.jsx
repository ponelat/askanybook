export default function Link({className='', ...props}) {
  return (
    <a className={ `${className} text-grey-400 font-bold hover:text-gray-900 hover:underline`} {...props}></a>
  )
  
}
