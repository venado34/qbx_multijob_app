if Config.Debug then print("[JobSelector] Client script started.") end

while GetResourceState("lb-phone") ~= "started" do
    Wait(500)
end
if Config.Debug then print("[JobSelector] lb-phone has started.") end

local function AddApp()
    exports["lb-phone"]:AddCustomApp({
        identifier = Config.Identifier,
        name = Config.Name,
        description = Config.Description,
        developer = Config.Developer,
        defaultApp = Config.DefaultApp,
        size = 150,
        ui = GetCurrentResourceName() .. "/ui/dist/index.html",
        icon = "https://cdn-icons-png.flaticon.com/512/1946/1946488.png",
        fixBlur = true,
    })
end
AddApp()

-- This function is called by the UI when it needs the job list.
RegisterNUICallback('getJobs', function(data, cb)
    -- Create a temporary event handler to wait for the server's response.
    local function handleJobsResponse(availableJobs)
        if Config.Debug then print("[JobSelector] Client: Received jobs from server: " .. json.encode(availableJobs)) end
        cb(availableJobs)
        -- Clean up the event handler after we get the response to prevent memory leaks.
        RemoveEventHandler('job-selector:client:receiveAvailableJobs', handleJobsResponse)
    end

    -- Register the handler and then trigger the server event to ask for the jobs.
    AddEventHandler('job-selector:client:receiveAvailableJobs', handleJobsResponse)
    if Config.Debug then print("[JobSelector] Client: Requesting available jobs from server.") end
    TriggerServerEvent('job-selector:server:requestAvailableJobs')
end)

-- This function is called by the UI when a job button is clicked.
RegisterNUICallback('setJob', function(data, cb)
    if data and data.jobName then
        if Config.Debug then print("[JobSelector] Client: Sending job change event to server for job: " .. data.jobName) end
        TriggerServerEvent('job-selector:server:changeJob', data.jobName)
        cb('ok')
    else
        if Config.Debug then print("[JobSelector] Client ERROR: 'setJob' callback received invalid data.") end
        cb('error')
    end
end)