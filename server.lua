if Config.Debug then print("[JobSelector] Server script started.") end

-- This is a standard event that the client will trigger directly.
RegisterNetEvent('job-selector:server:requestAvailableJobs', function()
    local source = source
    local Player = exports.qbx_core:GetPlayer(source)

    if not Player then
        if Config.Debug then print("[JobSelector] Server ERROR: Could not get player object for source " .. tostring(source)) end
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
    
    if Config.Debug then print("[JobSelector] Server: Sending available jobs to client: " .. json.encode(availableJobs)) end
    -- We send the data back to the client with a separate event.
    TriggerClientEvent('job-selector:client:receiveAvailableJobs', source, availableJobs)
end)

-- This event is triggered by the client when a job button is pressed.
RegisterNetEvent('job-selector:server:changeJob', function(jobName)
    local playerId = source
    local Player = exports.qbx_core:GetPlayer(playerId)

    if not Player then return end

    if Config.Debug then print(string.format("[JobSelector] Server: Changing primary job for %s to %s", Player.PlayerData.citizenid, jobName)) end
    exports.qbx_core:SetPlayerPrimaryJob(Player.PlayerData.citizenid, jobName)
end)