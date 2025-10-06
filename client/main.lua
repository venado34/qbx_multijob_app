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

-- This is now a permanent, secure event handler to receive the job list from the server
RegisterNetEvent('job-selector:client:receiveAvailableJobs', function(availableJobs)
    if Config.Debug then print("[JobSelector] Client: Received jobs from server: " .. json.encode(availableJobs)) end
    -- Send the received jobs to the UI via a standard NUI message
    SendNUIMessage({
        action = 'setJobs',
        jobs = availableJobs
    })
end)

-- This function is called by the UI when it opens and wants to get the list of jobs
RegisterNUICallback('requestJobs', function(data, cb)
    if Config.Debug then print("[JobSelector] Client: UI is requesting jobs. Forwarding request to server.") end
    -- Tell the server to send us the jobs. The response will be handled by the NetEvent above.
    TriggerServerEvent('job-selector:server:requestAvailableJobs')
    cb('ok') -- Immediately acknowledge the UI's request
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