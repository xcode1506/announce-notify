local RSGCore = exports['rsg-core']:GetCoreObject()

-------------------------------------------------
-- JOB WHITELIST (STANDARD REDM SERVER STYLE)
-------------------------------------------------

local LawJobs = {
    vallaw = true,
    blklaw = true,
    strlaw = true,
    rholaw = true,
    lawman = true,
    sheriff = true
}

local MedicJobs = {
    medic = true,
    doctor = true,
    ems = true,
    valmedic = true,
    blkmedic = true,
    strawmedic = true
}

-------------------------------------------------
-- SEND PERMISSIONS WHEN PLAYER LOADS
-------------------------------------------------
RegisterNetEvent('RSGCore:Server:OnPlayerLoaded', function()
    local src = source
    SendPermissions(src)
end)

RegisterNetEvent('RSGCore:Server:OnJobUpdate', function()
    local src = source
    SendPermissions(src)
end)

-------------------------------------------------
-- PERMISSION BUILDER
-------------------------------------------------
function SendPermissions(src)

    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    local job = Player.PlayerData.job.name
    local onduty = Player.PlayerData.job.onduty

    local perms = {
        admin = IsPlayerAceAllowed(src,"command"),
        law = false,
        medic = false
    }

    -------------------------------------------------
    -- LAW CHECK
    -------------------------------------------------
    if LawJobs[job] and onduty then
        perms.law = true
    end

    -------------------------------------------------
    -- MEDIC CHECK (FIX HERE)
    -------------------------------------------------
    if MedicJobs[job] and onduty then
        perms.medic = true
    end

    TriggerClientEvent("kc-announce:setPerms", src, perms)
end

-------------------------------------------------
-- ANNOUNCE SEND (SECURE)
-------------------------------------------------
RegisterNetEvent("kc-announce:send", function(type,message)

    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    local job = Player.PlayerData.job.name
    local onduty = Player.PlayerData.job.onduty

    -------------------------------------------------
    -- SECURITY VALIDATION
    -------------------------------------------------
    if type == "admin" then
        if not IsPlayerAceAllowed(src,"command") then return end
    end

    if type == "law" then
        if not (LawJobs[job] and onduty) then return end
    end

    if type == "medic" then
        if not (MedicJobs[job] and onduty) then return end
    end

    -------------------------------------------------
    -- BROADCAST
    -------------------------------------------------
    TriggerClientEvent("kc-announce:show",-1,type,message)
end)

-------------------------------------------------
-- RESOURCE RESTART FIX (VERY IMPORTANT)
-------------------------------------------------
AddEventHandler('onResourceStart', function(resource)

    if resource ~= GetCurrentResourceName() then return end

    Wait(2000) -- tunggu RSG selesai sync player

    print("[kc-announce] Re-syncing permissions...")

    for _, src in pairs(GetPlayers()) do
        SendPermissions(tonumber(src))
    end
end)

CreateThread(function()
    while true do
        Wait(60000)
        for _, src in pairs(GetPlayers()) do
            SendPermissions(tonumber(src))
        end
    end
end)