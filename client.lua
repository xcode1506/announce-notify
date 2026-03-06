local permissions = {admin=false, law=false, medic=false}
local announceType = nil

-------------------------------------------------
-- PRIORITY LEVEL
-------------------------------------------------
local Priority = {
    admin = 3,
    law = 2,
    medic = 1
}

local currentPriority = 0
local isShowing = false
local queue = {}

-------------------------------------------------
-- RECEIVE PERMISSIONS
-------------------------------------------------
RegisterNetEvent("kc-announce:setPerms", function(perms)
    permissions = perms
end)

-------------------------------------------------
-- SAFE PANEL OPEN
-------------------------------------------------
local function TryOpen(type)

    if not permissions[type] then
        print("[kc-announce] No permission for "..type)
        return
    end

    announceType = type

    SetNuiFocus(true,true)

    SendNUIMessage({
        action="open",
        type=type
    })
end

RegisterCommand("announce", function() TryOpen("admin") end)
RegisterCommand("law", function() TryOpen("law") end)
RegisterCommand("medic", function() TryOpen("medic") end)

-------------------------------------------------
-- NUI CALLBACKS
-------------------------------------------------
RegisterNUICallback("send", function(data,cb)

    TriggerServerEvent(
        "kc-announce:send",
        announceType,
        data.message
    )

    SetNuiFocus(false,false)
    cb("ok")
end)

RegisterNUICallback("close", function(_,cb)
    SetNuiFocus(false,false)
    cb("ok")
end)

-------------------------------------------------
-- QUEUE PROCESSOR
-------------------------------------------------
local function ProcessQueue()

    if #queue == 0 then
        isShowing = false
        currentPriority = 0
        return
    end

    local data = table.remove(queue,1)

    isShowing = true
    currentPriority = Priority[data.type]

    -- UI handles sound now
    SendNUIMessage({
        action = "notify",
        type = data.type,
        message = data.message
    })

    Citizen.SetTimeout(8000,function()
        ProcessQueue()
    end)
end

-------------------------------------------------
-- RECEIVE ANNOUNCE
-------------------------------------------------
RegisterNetEvent("kc-announce:show", function(type,message)

    local newPriority = Priority[type]

    -- nothing showing
    if not isShowing then
        table.insert(queue,{type=type,message=message})
        ProcessQueue()
        return
    end

    -------------------------------------------------
    -- ADMIN PRIORITY OVERRIDE
    -------------------------------------------------
    if newPriority > currentPriority then

        SendNUIMessage({action="clear"})

        queue = {}
        isShowing = false
        currentPriority = 0

        table.insert(queue,{type=type,message=message})

        Wait(50)
        ProcessQueue()
        return
    end

    -- normal queue
    table.insert(queue,{type=type,message=message})
end)