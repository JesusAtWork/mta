-------------------------------------------------------------------------------
-- This file contains helper functions for use throughout the code
-------------------------------------------------------------------------------

spawnX = tonumber(get("spawnX"))
spawnY = tonumber(get("spawnY"))
spawnZ = tonumber(get("spawnZ"))
spawnR = tonumber(get("spawnR"))

-- Picks a random point within a radius from the given point
-- made lovingly with help from http://stackoverflow.com/a/5838991
-- i dont know trig
function randomPointInRadius(x, y, r)
	a = math.random()
	b = math.random()
	if (b < a) then
		a, b = b, a
	end
	
	offset_x = b*r*math.cos(2*math.pi*a/b)
	offset_y = b*r*math.sin(2*math.pi*a/b)
	
	return x+offset_x, y+offset_y
end

-- Handles spawning the player
-- Spawn location defined in config.lua
function doPlayerSpawn(player)
	
	randX, randY = randomPointInRadius(spawnX, spawnY, 5)
	spawnPlayer(player, randX, randY, spawnZ, spawnR)
	fadeCamera(player, true)
	setCameraTarget(player, player)
	
	model = getElementData(player, "model")
	if (model ~= false) then
		setElementModel(player, model)
	end
end

-- Returns true when the given player is driving a car
function isDriving(player) 
	return getPedOccupiedVehicleSeat(player) == 0
end

-- Teleports player to given position
-- optional parameters:
---	   angle - the angle the teleported element will be facing (z axis rotation) (doesn't change if nil)
--     radius - randomly teleports player within that radius of the coordiantes (0 if nil)
-- 	   keep_vehicle - players who are driving will keep their vehicle when teleporting if true (true if nil)
function teleport(player, x, y, z, angle, radius, keep_vehicle)
	if (radius==nil) then radius = 0 end
	if (keep_vehicle==nil) then keep_vehicle = true end
	
	--figure out what element to move and where
	element_to_move = player
	if (isDriving(player) and keep_vehicle) then
		element_to_move = getPedOccupiedVehicle(player)
	else
		removePedFromVehicle(player)
	end
	local x, y = randomPointInRadius(x, y, radius)
	
	-- deal with rotation
	local rx, ry, rz = getElementRotation(element_to_move)
	if (angle~=nil) then rz=angle end
	
	-- move them
	setElementRotation(element_to_move, 0, 0, rz)
	setElementPosition(element_to_move, x, y, z)
	
end