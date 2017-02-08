-------------------------------------------------------------------------------
-- Describes prodcedures to handle basic server events
-------------------------------------------------------------------------------


-- Executed when player joins the server
function joinHandler()
	outputChatBox(string.format("%s has joined the server!", getPlayerName(source)))
	
	-- boosting
	bindKey(source, "mouse1", "down", doBoost)
	setElementData(source, "boost", 0)
	
	doPlayerSpawn(source)
end
addEventHandler("onPlayerJoin", getRootElement(), joinHandler)


-- Wasted Handler
function wastedHandler()
	-- store their model to reset after they respawn
	model = getElementModel(source)
	setElementData(source, "model", model)
	
	-- respawn the player after 2 seconds
	setTimer(doPlayerSpawn, 5000, 1, source)
end
addEventHandler("onPlayerWasted", getRootElement(), wastedHandler)


-- Quit handler
function quitHandler(quitType)
	outputChatBox(string.format("%s has left the server (%s)", getPlayerName(source), quitType))
end
addEventHandler("onPlayerQuit", getRootElement(), quitHandler)

-- Boosting when the player clicks
function doBoost(player, key, keyState)
	local mult = getElementData(player, "boost")
	if (isDriving(player) and mult > 0) then
		local vehicle = getPedOccupiedVehicle(player)
		local vx, vy, vz = getElementVelocity(vehicle)
		setElementVelocity(vehicle, vx*mult, vy*mult, vz*mult)
	end
end