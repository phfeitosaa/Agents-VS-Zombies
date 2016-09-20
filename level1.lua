display.setStatusBar( display.HiddenStatusBar )

local composer = require( "composer" )
local scene = composer.newScene()
local json = require "json"
local mte = require("MTE.mte").createMTE()

-- load the physics data:
local physicsData = (require "physicsData").physicsData(0.5)

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

display.setDefault( "magTextureFilter", "nearest" )
display.setDefault( "minTextureFilter", "nearest" )
system.activate("multitouch")

-- player and zombies declarations:
local player1, player2, player3, zombies

-- var current char:
local currentChar

-- colision names:
local player1Name = "player1"
local player2Name = "player2"
local player3Name = "player3"
local zombiesName = "zombies"

-- Load the music of the game:
soundTable = {
	ready = audio.loadSound( "sounds/ready.ogg" )
}

-- Functions to setup chars:
-- PLAYER 1: --------------------
local loadplayer1 = function ()
	local spriteSheet = graphics.newImageSheet("sprites/player1_gun_sprite.png", {width = 48, height = 48, numFrames = 16})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  start = 1, time = 400, loopCount = 0},
		{name = "down", sheet = spriteSheet, start = 2, time = 400, loopCount = 0},
		{name = "left", sheet = spriteSheet, frames = {49, 50}, time = 400, loopCount = 0},
		{name = "up", sheet = spriteSheet, frames = {61, 62}, time = 400, loopCount = 0}
	}
	local player1 = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer =  mte.getSpriteLayer(1), 
		--locX = 50, 
		--locY = 70,
		levelWidth = 48,
		levelHeight = 48,
		name = "player1"
	}
	mte.physics.addBody( player1, "dynamic", physicsData:get("hitman1_gun") )
	mte.addSprite(player1, setup)
	mte.setCameraFocus(player1)
	return player1
end
--[[
	-- PLAYER 2: --------------
local loadplayer2 = function ()
	local spriteSheet = graphics.newImageSheet("spriteSheet.png", {width = 32, height = 32, numFrames = 96})
	local sequenceData = {		
		{name = "0", sheet = spriteSheet, frames = {85, 86}, time = 400, loopCount = 0},
		{name = "90", sheet = spriteSheet, frames = {73, 74}, time = 400, loopCount = 0},
		{name = "180", sheet = spriteSheet, frames = {49, 50}, time = 400, loopCount = 0},
		{name = "270", sheet = spriteSheet, frames = {61, 62}, time = 400, loopCount = 0}
	}
	local player = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer =  mte.getSpriteLayer(1), 
		locX = 53, 
		locY = 40,
		levelWidth = 32,
		levelHeight = 32,
		name = "player"
	}
	mte.addSprite(player, setup)
	mte.setCameraFocus(player)
	return player2
end

	-- PLAYER 3: --------------
local loadplayer3 = function ()
	local spriteSheet = graphics.newImageSheet("spriteSheet.png", {width = 32, height = 32, numFrames = 96})
	local sequenceData = {		
		{name = "0", sheet = spriteSheet, frames = {85, 86}, time = 400, loopCount = 0},
		{name = "90", sheet = spriteSheet, frames = {73, 74}, time = 400, loopCount = 0},
		{name = "180", sheet = spriteSheet, frames = {49, 50}, time = 400, loopCount = 0},
		{name = "270", sheet = spriteSheet, frames = {61, 62}, time = 400, loopCount = 0}
	}
	local player = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer =  mte.getSpriteLayer(1), 
		locX = 53, 
		locY = 40,
		levelWidth = 32,
		levelHeight = 32,
		name = "player"
	}
	mte.addSprite(player, setup)
	mte.setCameraFocus(player)
	return player3
end
]]--

function scene:create( event )
	local sceneGroup = self.view

	-- ENABLE PHYSICS: ---------------------------------------------------
	mte.enableBox2DPhysics()
	mte.physics.start()
	mte.physics.setGravity(0,0)
	mte.physics.setDrawMode("hybrid")
	mte.physics.pause()

	-- LOAD MAP: ----------------------------------------------------------
	mte.toggleWorldWrapX(false)
	mte.toggleWorldWrapY(false)
	mte.loadMap("levels/level1.tmx") 
	mte.drawObjects()
	map = mte.setCamera({levelPosX = 0, levelPosY = 0, blockScale = 18})
	mte.constrainCamera()

	-- LOAD CHARS: --------------------------------------------------------
	player1 = loadplayer1()
	player1.name = player1Name
	
	--[[
	player2 = loadplayer2()
	player2.name = player2Name

	player3 = loadplayer3()
	player3.name = player3Name
	]]--

	-- INSERT DPAD: -------------------------------------------------------
	local buttons = {}

	buttons[1] = display.newImage("/sprites/button.png")
	buttons[1].x = 10
	buttons[1].y = 245
	buttons[1].width = 45
	buttons[1].height = 31
	buttons[1].myName = "up"
	buttons[1].rotation = -90

	buttons[2] = display.newImage("/sprites/button.png")
	buttons[2].x = 10
	buttons[2].y = 291
	buttons[2].width = 45
	buttons[2].height = 31
	buttons[2].myName = "down"
	buttons[2].rotation = 90

	buttons[3] = display.newImage("/sprites/button.png")
	buttons[3].x = -12
	buttons[3].y = 268,5
	buttons[3].width = 45
	buttons[3].height = 31
	buttons[3].myName = "left"
	buttons[3].rotation = 180

	buttons[4] = display.newImage("/sprites/button.png")
	buttons[4].x = 32
	buttons[4].y = 268,5
	buttons[4].width = 45
	buttons[4].height = 31
	buttons[4].myName = "right"

	--all display objects must be inserted into group
	sceneGroup:insert( map )
	sceneGroup:insert( player1 )
	--sceneGroup:insert( player2 )
	--sceneGroup:insert( player3 )
	sceneGroup:insert( buttons[1] )
	sceneGroup:insert( buttons[2] )
	sceneGroup:insert( buttons[3] )
	sceneGroup:insert( buttons[4] )

	local yAxis = 0
	local xAxis = 0

local touchFunction = function(e)
	local eventName = e.phase
	local direction = e.target.myName
	local currentChar = player1
	
	if eventName == "began" or eventName == "moved" then
		if direction == "up" then 
			yAxis = -3
			xAxis = 0
		elseif direction == "down" then 
			yAxis = 3
			xAxis = 0
		elseif direction == "right" then
			xAxis = 3
			yAxis = 0
		elseif direction == "left" then
			xAxis = -3
			yAxis = 0
		end
	else 
		yAxis = 0
		xAxis = 0
	end
end

local j=1

for j=1, #buttons do 
	buttons[j]:addEventListener("touch", touchFunction)
end

local update = function()
    mte.update()
    local currentChar = player1
	currentChar.x = currentChar.x + xAxis
	currentChar.y = currentChar.y + yAxis

	if currentChar.x <= currentChar.width * .5 then 
		currentChar.x = currentChar.width * .5
	elseif currentChar.x >= screenW - currentChar.width * .5 then 
		currentChar.x = screenW - currentChar.width * .5
	end

	if currentChar.y <= currentChar.height * .5 then
		currentChar.y = currentChar.height * .5
	elseif currentChar.y >= screenH - currentChar.height * .5 then 
		currentChar.y = screenH - currentChar.height * .5
	end 
end

Runtime:addEventListener("enterFrame", update)

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		mte.physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		mte.physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[mte.physics] = nil
	mte.physics = nil
end

function update()
    mte.update()
end
    

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
--scene:addEventListener( "enterFrame", update )

-----------------------------------------------------------------------------------------

return scene