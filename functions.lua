-------------------------------------------------------------------------------
-- This file contains helper functions for use throughout the code
-------------------------------------------------------------------------------

spawnX = tonumber(get("spawnX"))
spawnY = tonumber(get("spawnY"))
spawnZ = tonumber(get("spawnZ"))

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
	model = getElementData(player, "model")
	if (model == false) then
		setElementModel(player, model)
	end
	
	randX, randY = randomPointInRadius(spawnX, spawnY, 5)
	spawnPlayer(player, randX, randY, spawnZ, 270)
	fadeCamera(player, true)
	setCameraTarget(player, player)
end

-- Returns true when the given player is driving a car
function isDriving(player) 
	return getPedOccupiedVehicleSeat(player) == 0
end

-- Teleports player to given position (or their car if they're driving)
function teleport(player, x, y, z, angle)
	angle = angle == nil and 0 or angle
	
	element_to_move = player
	if (isDriving(player)) then
		element_to_move = getPedOccupiedVehicle(player)
	end
	x, y = randomPointInRadius(x, y, 5)
	setElementPosition(element_to_move, x, y, z)
	setElementRotation(element_to_move, angle, 0, 0)
	
end