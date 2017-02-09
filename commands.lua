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
			outputChatBox(string.format("Vehicle \"%s\" not found!", param), player, 255, 128, 128)
		else
			-- try spawn a car at the player's position and put them in it
			local x, y, z = getElementPosition(player)
			local rx, ry, rz = getElementRotation(player)
			local vehicle = createVehicle(vehid, x, y, z, rx, ry, rz)
			
			-- check that the car was actually made (would get here if user typed a vehicle id that doesnt exist)
			if (not vehicle) then
				outputChatBox(string.format("Vehicle \"%s\" not found!", param), player)
			else 
				local dp = false
				-- if the player is driving right now, destroy the car they're in
				if (isDriving(player)) then
					local old_veh = getPedOccupiedVehicle(player)
					dp = isVehicleDamageProof(old_veh)
					destroyElement(old_veh)
				end
				-- carry over damage proof state from old car
				setVehicleDamageProof(vehicle, dp)
				
				warpPedIntoVehicle(player, vehicle)
			end
		end
	end
end
addCommandHandler("v", cmd_v)

-- /w
-- spawn a weapon by name
function cmd_w(player, cmd, param, param2)
	-- some weapons have a space in their name, etc
	if (param2) then
		param = param .. " " .. param2
	end
	
	if (param == nil) then
		outputChatBox("/w: Spawn a weapon", player)
		outputChatBox("Usage: /w (weapon name)", player)
	else
		local wepid = getWeaponIDFromName(param)
		if (wepid==false) then
			outputChatBox(string.format("Didn't find a weapon named \"%s\"!", param), player, 255, 128, 128)
		else
			giveWeapon(player, wepid, 32767, true)
		end
	end
end
addCommandHandler("w", cmd_w)

-- /dp
-- toggles damageproof state of the car the player is driving
function cmd_dp(player, cmd)
	-- make sure the player is driving a car
	if (not isDriving(player)) then
		outputChatBox("/dp: You need to be driving a car first!", player)
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
function cmd_boost(player, cmd, str)
	local str = math.floor(tonumber(str))
	if (str == nil or str < 0 or str > 3) then
		outputChatBox("Usage: /boost (strength)", player)
		outputChatBox("Strength can be between 1 and 3. Use \"/boost 0\" to disable boosting.", player)
	else
		if (str == 0) then
			outputChatBox("Boosting disabled.", player)
		else
			outputChatBox("Boosting strength set to " .. str .. ".", player)
		end
		setElementData(player, "boost", str)
			
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
	{{1997.7056884766, -807.38104248047, 132.71237182617, 140}},
	2
)

addTeleport(
	"grove",
	"Grove Street",
	{{2486.9033203125, -1666.9697265625, 13.34375}},
	10
)

addTeleport(
	"doherty",
	"Doherty Garage",
	{{-2025.6005859375, 139.9794921875, 28.8359375, 270}},
	5
)

addTeleport(
	"airstrip",
	"Abandoned Airstrip",
	{{380.607421875, 2536.4228515625, 16.208227157593, 180}},
	6
)

addTeleport(
	"lvap",
	"Las Venturas Airport",
	{{1675.9951171875, 1593.9072265625, 10.8203125, 90}},
	10
)

addTeleport(
	"chiliad",
	"Mount Chiliad",
	{{-2330.919921875, -1614.7958984375, 483.44393920898, 215}},
	10
)

addTeleport(
	"chiliadbase",
	"Mount Chiliad Base",
	{{-2389.0166015625, -2177.4970703125, 33.016147613525, 195}},
	5
)

addTeleport(
	"ninorace",
	"Nino Race",
	{{2983.4404296875, -1640.744140625, 35.409103393555, 165.5}},
	5
)

addTeleport(
	"toastarena",
	"Toast's Arena",
	{
		{2692.5, -1799.3, 38.6},
		{2743.8, -1712, 41.9},
		{2783.6, -1795.1, 39},
		{2711.8, -1746.5, 42.5},
		{2783.2, -1729.4, 39.5}
	},
	2,
	false
)
