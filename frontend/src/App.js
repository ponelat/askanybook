import {useEffect, useState} from 'react'

function App() {
    const [health, setHealth] = useState(null)
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState(null)
    useEffect(() => {
        setLoading(true)
	fetch('/health')
	    .then(res => res.json())
	    .then(body => {
		setHealth(body)
		setLoading(false)
	    }, err => {
                setError(err)
		setLoading(false)
            })
	
    }, [])

    if(loading) {
        return (
	    <div>
	      'Loading...'
	    </div>
        )
    }

    if(error) {
        return (
            <p className="p-4 fg-red">
              {error+''}
            </p>
        )
    }

    return (
	<div className="p-4 text-green-900">
          <pre>
            <code>
	      Healthy: {JSON.stringify(health, null, 2)}
            </code>
          </pre>
	</div>
    );
}

export default App;
