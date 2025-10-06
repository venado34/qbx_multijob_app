if Config.Debug then print("[JobSelector] Client script started.") end

-- Wait for lb-phone to be ready before trying to add the app.
while GetResourceState("lb-phone") ~= "started" do
    Wait(500)
end
if Config.Debug then print("[JobSelector] lb-phone has started.") end

-- Function to register the app with lb-phone.
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

-- This is triggered by the UI when the app is opened.
RegisterNUICallback('getJobs', function(data, cb)
    -- It uses the standard QBCore callback system to ask the server for the list of available jobs.
    QBCore.Functions.TriggerCallback('job-selector:server:getAvailableJobs', function(availableJobs)
        -- Once the server responds, it sends the list back to the UI.
        cb(availableJobs)
    end)
end)

-- This is triggered by the UI when a job button is clicked.
RegisterNUICallback('setJob', function(data, cb)
    if data and data.jobName then
        -- It tells the server to run the 'changeJob' event.
        TriggerServerEvent('job-selector:server:changeJob', data.jobName)
        cb('ok')
    else
        cb('error')
    end
end)

