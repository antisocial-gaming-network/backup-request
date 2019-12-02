-- Simple backup Command (With Location & Blip) -- 
		-- Made By Chemistry --

       -- base script by chezza -- 

displayLocation = true  -- By Changing this to 'false' it will make it so your location is not displayed in the Notification --
blips = true -- By Changing this to 'false' it will disable 10-32 call blips meaning your location will not be shown on the map --
disableChatCalls = false -- By Chaning this to 'false' it wiell mak it so 10-32 call are not displayed in chat (Recommended to have Discord Webhook setup if disabling this) --
webhookurl = 'Your Webhook Here' -- Add your discord webhook url here, if you do not want this leave it blank (More info on FiveM post) --
ondutymode = true -- By chaning this to 'false' it will make it so everyone can see 10-32 request (NOT ADVISED TO TURN OFF)--

-- Code --

local onduty = false

RegisterServerEvent('32')
AddEventHandler('32', function(location, msg, x, y, z, name, ped)
	local playername = GetPlayerName(source)
	local ped = GetPlayerPed(source)
	if displayLocation == false then
		if disableChatCalls == true then
			sendDiscord('Dispatch', '**9Backup Request |  Officer: **' .. playername .. '** | Respond Code: **' .. msg)  
		else
			sendDiscord('Dispatch', '**9Backup Request |  Officer: **' .. playername .. '** | Respond Code: **' .. msg)  
		end
	else
		if disableChatCalls == false then
			if ondutymode then
				TriggerClientEvent('32:sendtoteam', -1, playername, location, msg, x, y, z)
			else 
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You Have Requested Backup' } )
			end
			sendDiscord('Dispatch', '**Backup Request | Officer: **' .. playername .. '** | Location: **' .. location .. '** | Respond Code: **' .. msg)
		else
			sendDiscord('Dispatch', '**Backup Request | Officer: **' .. playername .. '** | Location: **' .. location .. '** | Respond Code: **' .. msg)
		end
		if blips == true then
			if not ondutymode then
				TriggerClientEvent('32:setBlip', -1, name, x, y, z)
			end 
		end
	end
end)

RegisterServerEvent('32:sendmsg')
AddEventHandler('32:sendmsg', function(name, location, msg, x, y, z)
   TriggerClientEvent("pNotify:SendNotification", -1, {
            text = "<b style='color:lightblue'>10-32 Request</b> <br /><br /> <b style='color:white'>Location: " .. location .. "</b><br /><br /><b style='color:white'>Proceed with caution</b>",
            type = "warning",
            queue = "centerRight",
            timeout = 10000,
			layout = "centerRight"
        })
	if blips then
		TriggerClientEvent('32:setBlip', source, name, x, y, z)
	end
end)

function sendDiscord(name, message)
	local content = {
        {
        	["color"] = '5015295',
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Made by Chemistry",
            },
        }
    }
  	PerformHttpRequest(webhookurl, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = content}), { ['Content-Type'] = 'application/json' })
end


	