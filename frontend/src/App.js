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
        return 'Loading...'
    }

    if(error) {
        return (
            <p style={{color: 'red', padding: '20px'}}>
              {error+''}
            </p>
        )
    }

    return (
	<div style={{padding: '20px'}}>
          <pre>
            <code>
	      Health: {JSON.stringify(health, null, 2)}
            </code>
          </pre>
	</div>
    );
}

export default App;
