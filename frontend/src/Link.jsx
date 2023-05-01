export default function Link({className='', ...props}) {
  return (
    <a className={ `${className} text-grey-900 font-bold hover:underline`} {...props}></a>
  )
  
}
