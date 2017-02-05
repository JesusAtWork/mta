-------------------------------------------------------------------------------
-- Describes prodcedures to handle basic server events
-------------------------------------------------------------------------------


-- Executed when player joins the server
function joinHandler()
	-- boosting
	bindKey(source, "mouse1", "down", doBoost)
	setElementData(source, "boost", 0)
	
	outputChatBox("Welcome to My Server", source)
	doPlayerSpawn(source)
end
addEventHandler("onPlayerJoin", getRootElement(), joinHandler)


-- Wasted Handler
function wastedHandler()
	-- store their model to reset after they respawn
	model = getElementModel(player)
	setElementData(player, "model", model)
	
	-- respawn the player after 2 seconds
	setTimer(doPlayerSpawn, 5000, 1, source)
end
addEventHandler("onPlayerWasted", getRootElement(), wastedHandler)


-- Boosting when the player clicks
function doBoost(player, key, keyState)
	local mult = getElementData(player, "boost")
	if (isDriving(player) and mult > 0) then
		local vehicle = getPedOccupiedVehicle(player)
		local vx, vy, vz = getElementVelocity(vehicle)
		setElementVelocity(vehicle, vx*mult, vy*mult, vz*mult)
	end
end