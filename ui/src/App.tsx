import { ReactNode, useEffect, useState } from 'react';
import './App.css';
import Frame from './components/Frame';

const devMode = !window?.['invokeNative'];

async function fetchNui<T>(eventName: string, data: unknown = {}): Promise<T> {
    const resourceName = window.GetParentResourceName ? window.GetParentResourceName() : 'qbx_multijob_app';
    const resp = await fetch(`https://${resourceName}/${eventName}`, {
        method: 'post',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data),
    });
    return await resp.json();
}

const App = () => {
    const [jobs, setJobs] = useState<{ [key: string]: number }>({});

    useEffect(() => {
        if (devMode) {
            setJobs({ police: 4, taxi: 0 });
            document.body.style.visibility = 'visible';
            return;
        }

        fetchNui<{ [key: string]: number }>('getJobs').then(setJobs);
    }, []);

    const handleSetJob = (jobName: string) => {
        if (!devMode) {
            fetchNui('setJob', { jobName });
        } else {
            console.log(`(Dev Mode) Would be setting active job to ${jobName}`);
        }
    };

    return (
        <AppProvider>
            <div className="app">
                <div className="app-wrapper">
                    <div className="header">
                        <div className="title">Job Selector</div>
                    </div>
                    <div className="button-wrapper">
                        {jobs && Object.keys(jobs).length > 0 ? (
                            Object.entries(jobs).map(([jobName]) => ( 
                                <button key={jobName} onClick={() => handleSetJob(jobName)}>
                                    {jobName.charAt(0).toUpperCase() + jobName.slice(1)}
                                </button>
                            ))
                        ) : (
                            <div className="subtitle">No other jobs available</div>
                        )}
                    </div>
                </div>
            </div>
        </AppProvider>
    );
};

const AppProvider = ({ children }: { children: ReactNode }) => {
    if (devMode) {
        return (
            <div className="dev-wrapper">
                <Frame>{children}</Frame>
            </div>
        )
    } else return children;
};

export default App;

