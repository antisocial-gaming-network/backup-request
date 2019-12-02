-- Simple backup Command (With Location & Blip) -- 
		-- Made By Chemistry --

      -- base script by chezza -- 

displayTime = 300 -- Refreshes Blips every 5 Minutes by Default --  
ondutycommand = 'police' -- Change this if you already have a 'onduty' command already set --
passwordmode = false -- By Changing this to 'false' it will make it so you need a password to go on-duty --  example =  password = '32' --

-- Code --

blip = nil
blips = {}

local onduty = false

RegisterCommand(ondutycommand, function(source, args)
    if passwordmode then 
        if args[1] == password then
            if not onduty then 
                onduty = true
                exports['mythic_notify']:SendAlert('success', 'You are now onduty and able to recieve backup calls', 5000)
            else
                onduty = false
                 exports['mythic_notify']:SendAlert('error', 'You are now offduty and no longer able to recieve backup calls', 5000)
            end
        else
                 exports['mythic_notify']:SendAlert('error', 'You are now offduty and no longer able to recieve backup calls', 5000)
        end
    else
        if not onduty then 
            onduty = true
              exports['mythic_notify']:SendAlert('success', 'You are now onduty and able to recieve backup calls', 5000)
        else
            onduty = false
             exports['mythic_notify']:SendAlert('error', 'You are now offduty and no longer able to recieve backup calls', 5000)
        end
    end 
end)


Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/backup', 'Request Backup from officers', {
    { name="Respond Code", help="1, 2, 3" }
})
end)
RegisterNetEvent('32:setBlip')
AddEventHandler('32:setBlip', function(name, x, y, z)
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 381)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('10-32 Request - ' .. name)
    EndTextCommandSetBlipName(blip)
    table.insert(blips, blip)
    Wait(displayTime * 1000)
    for i, blip in pairs(blips) do 
        RemoveBlip(blip)
    end
end)

RegisterNetEvent('32:sendtoteam')
AddEventHandler('32:sendtoteam', function(name, location, msg, x, y, z)
    if onduty then 
        TriggerServerEvent('32:sendmsg', name, location, msg, x, y, z)
    end
end)

-- Command -- 

RegisterCommand('backup', function(source, args)
    local name = GetPlayerName(PlayerId())
    local ped = GetPlayerPed(PlayerId())
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local street = GetStreetNameAtCoord(x, y, z)
    local location = GetStreetNameFromHashKey(street)
    local msg = table.concat(args, ' ')
    if args[1] == nil then
             exports['mythic_notify']:SendAlert('inform', 'Please specify code 1, code 2, code3, code 5', 5000)
    else
        TriggerServerEvent('32', location, msg, x, y, z, name)
    end
end)

