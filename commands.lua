-- /kill
-- kills the player
function cmd_kill(player, cmd)
	setElementHealth(player, 0)
end
addCommandHandler("kill", cmd_kill)

-- /pos
-- prints player's position and rotation to the chat and server console
function cmd_pos(player, cmd)
	local x, y, z = getElementPosition(player)
	local rx, ry, rz = getElementRotation(player)
	local msg = x .. ", " .. y .. ", " .. z .. " : ".. rx .. ", " .. ry .. ", " .. rz
	print(msg)
	outputChatBox(msg, player)
end
addCommandHandler("pos", cmd_pos)

-- /v
-- puts the player in a vehicle given the vehicle ID they type for the argument
function cmd_v(player, cmd, vehid)
	local vehid = tonumber(vehid)
	if (vehid == nil) then
		outputChatBox("/v: Spawn a vehicle", player)
		outputChatBox("Usage: /v (vehicle id)", player)
	else
		-- spawn a car at the player's position and put them in it
		local x, y, z = getElementPosition(player)
		local rx, ry, rz = getElementRotation(player)
		local vehicle = createVehicle(vehid, x, y, z, rx, ry, rz)
		warpPedIntoVehicle(player, vehicle)
	end
end
addCommandHandler("v", cmd_v)

-- /dp
-- toggles damageproof state of the car the player is driving
function cmd_dp(player, cmd)
	-- make sure the player is driving a car
	if (not isDriving(player)) then
		outputChatBox("/dp: You need to be driving a car first!")
	else
		local vehicle = getPedOccupiedVehicle(player)
		local new_state = not isVehicleDamageProof(vehicle)
		setVehicleDamageProof(vehicle, new_state)
		
		outputChatBox(new_state and "Your vehicle is now damage proof." or "Your vehicle is no longer damage proof.", player)
	end
end
addCommandHandler("dp", cmd_dp)

-- /respawn
-- respawns the player
-- this is a very complicated function so be sure that you pay close attention
function cmd_respawn(player, cmd)
	doPlayerSpawn(player)
end
addCommandHandler("respawn", cmd_respawn)

-- boosting: velocity vector shouldnt be more than 1000
function cmd_boost(player, cmd, multiplier)
	local multiplier = tonumber(multiplier)
	if (multiplier == nil or multiplier < 0 or multiplier > 100) then
		outputChatBox("Usage: /boost (multiplier value)", player)
		outputChatBox("Multiplier can be between 0 and 100. Use \"/boost 0\" to disable boosting.", player)
	else
		if (multiplier == 0) then
			outputChatBox("Boosting disabled.", player)
		else
			outputChatBox("Boosting multiplier set to " .. multiplier .. ".")
		end
		setElementData(player, "boost", multiplier)
			
	end
end
addCommandHandler("boost", cmd_boost)

--[[
	Teleports
]]
addCommandHandler("lsriver", function(player, cmd) 
	teleport(player, 2866.9174804688, -234.806640625, 1225.9116210938, 167) 
end)

addCommandHandler("matt", function(player, cmd) 
	teleport(player, 1982.701171875, -816.9443359375, 130.39364624023, 150) 
end)