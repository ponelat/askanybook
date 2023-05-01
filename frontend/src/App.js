import {useEffect} from 'react'
import ErrorPage from './ErrorPage'
import useHttp from './useHttp'

function App() {
  const [healthState, checkHealth] = useHttp('/health')
  const isUnhealthy = healthState.matches('error')

  useEffect(() => {
    checkHealth()
  }, [checkHealth])

  if(isUnhealthy) {
    return <ErrorPage {...healthState.context} unexpected="GET /health came back negative" />
  }

  return (
    <div className="p-4 text-gray-800" >
      Lets go
    </div>
  );
}

export default App;
