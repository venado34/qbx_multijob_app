if Config.Debug then print("[JobSelector] Server script has started.") end

-- This event listens for a request from the client to get the available jobs.
RegisterNetEvent('job-selector:server:requestJobs', function()
    local source = source
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return end

    local availableJobs = {}
    -- Check if the player has any jobs listed in their data.
    if Player.PlayerData.jobs and next(Player.PlayerData.jobs) then
        -- Loop through all the player's jobs.
        for jobName, grade in pairs(Player.PlayerData.jobs) do
            -- Only add the job to the list if it is NOT their current active job.
            if jobName ~= Player.PlayerData.job.name then
                availableJobs[jobName] = grade
            end
        end
    end
    
    if Config.Debug then print(string.format("[JobSelector] Server: Sending jobs to Player %d: %s", source, json.encode(availableJobs))) end
    -- Send the final list of switchable jobs back to the specific client that requested them.
    TriggerClientEvent('job-selector:client:receiveJobs', source, availableJobs)
end)

-- This event is triggered by the client when a job button is pressed.
RegisterNetEvent('job-selector:server:changeJob', function(jobName)
    local playerId = source
    local Player = exports.qbx_core:GetPlayer(playerId)

    if not Player then return end

    exports.qbx_core:SetPlayerPrimaryJob(Player.PlayerData.citizenid, jobName)
end)