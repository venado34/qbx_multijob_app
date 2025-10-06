import React, { ReactNode, useEffect, useState } from 'react';
import './App.css';
import Frame from './components/Frame';

const devMode = !window?.['invokeNative'];

// We keep this function for simple NUI callbacks like requesting jobs or setting a job
async function fetchNui<T>(eventName: string, data: unknown = {}): Promise<T> {
    const resourceName = (window as any).GetParentResourceName ? (window as any).GetParentResourceName() : 'qbx_multijob_app';
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
        // This function will handle messages sent from the LUA script (SendNUIMessage)
        const handleMessage = (event: MessageEvent) => {
            const { action, jobs } = event.data;
            if (action === 'setJobs') {
                setJobs(jobs);
            }
        };

        // Add the event listener to listen for NUI messages from the client script
        window.addEventListener('message', handleMessage);

        // When the app first opens, send a message to the client script telling it to request the jobs from the server
        fetchNui('requestJobs');

        // This is a cleanup function that runs when the app is closed. It removes the event listener to prevent memory leaks.
        return () => {
            window.removeEventListener('message', handleMessage);
        };
    }, []); // The empty array ensures this effect only runs once when the app opens

    const handleSetJob = (jobName: string) => {
        // This part remains the same, as it's a simple one-way message
        fetchNui('setJob', { jobName });
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
                            Object.entries(jobs).map(([jobName, grade]) => (
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

