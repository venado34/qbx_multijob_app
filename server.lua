if Config.Debug then print("[JobSelector] Server script has started successfully.") end

lib.callback.register('job-selector:server:getAvailableJobs', function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return {} end

    local availableJobs = {}
    for jobName, grade in pairs(Player.PlayerData.jobs) do
        if jobName ~= Player.PlayerData.job.name then
            availableJobs[jobName] = grade
        end
    end
    if Config.Debug then print(string.format("[JobSelector] Server: Sending available jobs to Player %d: %s", source, json.encode(availableJobs))) end
    return availableJobs
end)

RegisterNetEvent('job-selector:server:changeJob', function(jobName)
    local playerId = source
    local Player = exports.qbx_core:GetPlayer(playerId)

    if not Player then
        if Config.Debug then print(string.format("[JobSelector] Server ERROR: Could not get player object for ID %d.", playerId)) end
        return
    end

    if Config.Debug then
        print(string.format("[JobSelector] Server: Received request from citizenid '%s' to change active job to '%s'.", Player.PlayerData.citizenid, jobName))
    end

    local success, errorResult = exports.qbx_core:SetPlayerPrimaryJob(Player.PlayerData.citizenid, jobName)

    if success then
        if Config.Debug then print("[JobSelector] Server: Successfully changed active job for " .. Player.PlayerData.citizenid) end
    else
        if Config.Debug then print("[JobSelector] Server ERROR: SetPlayerPrimaryJob failed. Reason: " .. (errorResult and errorResult.message or "Unknown")) end
    end
end)

