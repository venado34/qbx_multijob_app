if Config.Debug then print("[JobSelector] Server script has started and is waiting for QBCore to be ready.") end

-- This event handler ensures that the code inside only runs after QBCore is fully loaded.
AddEventHandler('QBCore:Ready', function()
    if Config.Debug then print("[JobSelector] ### QBCore IS READY! ### Registering server callbacks.") end

    -- This is the standard QBCore way to create a callback that the client can request data from.
    QBCore.Functions.CreateCallback('job-selector:server:getAvailableJobs', function(source, cb)
        local Player = exports.qbx_core:GetPlayer(source)
        if not Player then
            cb({})
            return
        end

        local availableJobs = {}
        if Player.PlayerData.jobs and next(Player.PlayerData.jobs) then
            for jobName, grade in pairs(Player.PlayerData.jobs) do
                if jobName ~= Player.PlayerData.job.name then
                    availableJobs[jobName] = grade
                end
            end
        end
        
        cb(availableJobs)
    end)
end)

-- This event is triggered by the client when a job button is pressed.
RegisterNetEvent('job-selector:server:changeJob', function(jobName)
    local playerId = source
    local Player = exports.qbx_core:GetPlayer(playerId)

    if not Player then return end

    exports.qbx_core:SetPlayerPrimaryJob(Player.PlayerData.citizenid, jobName)
end)