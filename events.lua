-------------------------------------------------------------------------------
-- Describes prodcedures to handle basic server events
-------------------------------------------------------------------------------

-- Do things when the resource starts
function resourceLaunch()
	-- take care of people who are already connected to the server when the resource starts
	local players = getElementsByType("player")
	for key, player in ipairs(players) do
		doPlayerSettings(player)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), resourceLaunch)

function joinHandler()
	outputChatBox(string.format("%s has joined the server!", getPlayerName(source)), getRootElement(), 128, 128, 255)
	doPlayerSettings(source)
	doPlayerSpawn(source)
end
addEventHandler("onPlayerJoin", getRootElement(), joinHandler)


-- Wasted Handler
function wastedHandler()
	-- store their model to reset after they respawn
	local model = getElementModel(source)
	setElementData(source, "model", model)
	
	-- respawn the player after 2 seconds
	setTimer(doPlayerSpawn, 5000, 1, source)
end
addEventHandler("onPlayerWasted", getRootElement(), wastedHandler)


-- Quit handler
function quitHandler(quitType)
	outputChatBox(string.format("%s has left the server (%s)", getPlayerName(source), quitType), getRootElement(), 128, 128, 255)
end
addEventHandler("onPlayerQuit", getRootElement(), quitHandler)

-- Get rid of vehicles when they explode 
--(i was gonna put a delay but it looks like they actually get destoryed when they blow up which is cool)
function vehicleExplodeHandler()
	destroyElement(source)
end
addEventHandler("onVehicleExplode", getRootElement(), vehicleExplodeHandler)

-- Take care of things that need to be to a player when they start playing
-- Executed when resource loads and when they join the server
function doPlayerSettings(player)
	-- Set up boosting
	bindKey(player, "mouse1", "down", doBoost)
	setElementData(player, "boost", 0)
	
	-- store model preference
	setElementData(source, "model", getElementModel(player))
end

-- maps boosting strength settings to multipler values
boost_coeffs = {1.5, 2.5, 10}
-- Boosting when the player clicks
function doBoost(player, key, keyState)
	local str = getElementData(player, "boost")
	local coef = boost_coeffs[str]
	if (isDriving(player) and str > 0 and coef ~= nil) then
		local vehicle = getPedOccupiedVehicle(player)
		local vx, vy, vz = getElementVelocity(vehicle)
		setElementVelocity(vehicle, vx*coef, vy*coef, vz*coef)
	end
end
