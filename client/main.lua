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

RegisterNUICallback('getJobs', function(data, cb)
    if Config.Debug then print("[JobSelector] Client: Requesting available jobs from server...") end
    -- Use the server callback to get a fresh, filtered list of jobs
    local availableJobs = lib.callback.await('job-selector:server:getAvailableJobs', false)
    if Config.Debug then print("[JobSelector] Client: Received available jobs: " .. json.encode(availableJobs)) end
    cb(availableJobs)
end)

RegisterNUICallback('setJob', function(data, cb)
    if data and data.jobName then
        if Config.Debug then print("[JobSelector] Client: Triggering server event to set job to " .. data.jobName) end
        TriggerServerEvent('job-selector:server:changeJob', data.jobName)
        cb('ok')
    else
        cb('error')
    end
end)