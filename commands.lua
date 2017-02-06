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
-- puts the player in a vehicle given the vehicle name or ID
function cmd_v(player, cmd, param, param2)
	-- some cars have a space in their name, so handle that case
	if(param2) then
		param = param .. " " .. param2
	end
	
	-- check that the player provided a parameter
	if (param == nil) then
		outputChatBox("/v: Spawn a vehicle", player)
		outputChatBox("Usage: /v (vehicle name/id)", player)
	else
		-- check if the player typed an id or a name and convert it if necessary
		if (tonumber(param) == nil) then 
			vehid = getVehicleModelFromName(param)
		else
			vehid = tonumber(param)
		end
		
		-- check that we have a number and not a bool or a nil or something
		if (type(vehid)~='number') then
			outputChatBox(string.format("Vehicle \"%s\" not found!", param), player)
		else
			-- try spawn a car at the player's position and put them in it
			local x, y, z = getElementPosition(player)
			local rx, ry, rz = getElementRotation(player)
			local vehicle = createVehicle(vehid, x, y, z, rx, ry, rz)
			
			-- check that the car was actually made (would get here if user typed a vehicle id that doesnt exist)
			if (not vehicle) then
				outputChatBox(string.format("Vehicle \"%s\" not found!", param), player)
			else 
				-- if the player is driving right now, destroy the car they're in
				if (isDriving(player)) then
					destroyElement(getPedOccupiedVehicle(player))
				end
				warpPedIntoVehicle(player, vehicle)
			end
		end
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

	Teleporting
	
]]

--[[
	addTeleport
	Add a location that players can teleport to by command
	
	parameters:
		cmdtext - the command text that the player types to teleport
		name - a name for the location
		tbl_coords - a 2-dimensional table of coordinates and angle, e.g.:
			{
				x, y, z, angle
				{10, 20, 30, 360},
				{5, 5, 5, nil},
				{3, 5, 7}
			}
			players will be randomly teleported to one of these locations
			set angle to nil/don't specify if you want to maintain the facing direction
		radius - the player will spawn randomly within a radius this many units from the chosen coords (0 if not specified)
		keep_vehicle - if true, the player will keep the car they're driving when they teleport (true if not specified)
		
]]
function addTeleport(cmdtext, name, tbl_coords, radius, keep_vehicle)
	addCommandHandler(cmdtext, function(player, cmd)
		coords = tbl_coords[math.random(#tbl_coords)]
		teleport(player, coords[1], coords[2], coords[3], coords[4], radius, keep_vehicle)
		outputChatBox(string.format("TELEPORT: %s teleported to %s (/%s)", getPlayerName(player), name, cmd), getRootElement(), 32, 192, 32)
	end)
end

addTeleport(
	"lsriver", 
	"Los Santos River Ramp", 
	{{2866.9174804688, -234.806640625, 1225.9116210938, 167}},
	5
)

addTeleport(
	"matt",
	"Matt's Sanchez Parkour",
	{{1982.701171875, -816.9443359375, 130.39364624023, 150}},
	3
)

addTeleport(
	"grove",
	"Grove Street",
	{{2486.9033203125, -1666.9697265625, 13.34375}},
	10
)

addTeleport(
	"doherty"
	"Doherty Garage"
	{{-2025.6005859375, 139.9794921875, 28.8359375, 270}}
	5
)