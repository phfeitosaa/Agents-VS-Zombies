local composer = require( "composer" )
local scene = composer.newScene()
local mte = require("MTE.mte").createMTE()

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "magTextureFilter", "nearest" )
display.setDefault( "minTextureFilter", "nearest" )
system.activate("multitouch")

-- player and zombies declarations:
local player1, player2, player3, zombies
local yAxis, xAxis = 0, 0

-- var current char:
local currentChar

-- collision names:
local player1Name = "player1"
local player2Name = "player2"
local player3Name = "player3"
local zombiesName = "zombies"

-- Load the music of the game:
soundTable = {
	music = audio.loadStream( "sounds/dark_fallout.ogg" )
}

-- Functions to setup chars:
-- PLAYER 1: --------------------
local loadplayer1 = function ()
    
	local spriteSheet = graphics.newImageSheet("sprites/player1_gun.png", {width = 48, height = 48, numFrames = 1})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  frames = {1}, time = 400},
		{name = "down", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "left", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "up", sheet = spriteSheet, frames = {1}, time = 400}
	}
	local player1 = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 3, 
		locX = 15,
		locY = 10,
		levelWidth = 48,
		levelHeight = 48
	}
	mte.physics.addBody( player1, "dynamic" )
	mte.addSprite(player1, setup)
	mte.setCameraFocus(player1)
	player1:setSequence("up")
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

function touchFunction(e)
	local eventName = e.phase
	local direction = e.target.myName
	local currentChar = player1
	
	if eventName == "began" or eventName == "moved" then
		if direction == "up" then 
			yAxis = -6
			xAxis = 0
			player1.rotation = 0
		elseif direction == "down" then 
			yAxis = 6
			xAxis = 0
			player1.rotation = 180
		elseif direction == "right" then
			xAxis = 6
			yAxis = 0
			player1.rotation = 90
		elseif direction == "left" then
			xAxis = -6
			yAxis = 0
			player1.rotation = -90
		end
	else 
		yAxis = 0
		xAxis = 0
	end
end

function RotationFunction(e)
	local eventName = e.phase
	local direction = e.target.myName
	local currentChar = player1
	
	if eventName == "began" or eventName == "moved" then
		if direction == "up" then 
			player1.rotation = 0
		elseif direction == "down" then 
			player1.rotation = 180
		elseif direction == "right" then
			player1.rotation = 90
		elseif direction == "left" then
			player1.rotation = -90
		end
	else 
		yAxis = 0
		xAxis = 0
	end
end

function test(e)
	print("eita")
end

function scene:create( event )
	local sceneGroup = self.view

	-- ENABLE PHYSICS: ---------------------------------------------------
	mte.enableBox2DPhysics()
	mte.physics.start()
	mte.physics.setGravity(0,0)
	--mte.physics.setDrawMode("hybrid")

	-- LOAD MAP: ----------------------------------------------------------
	mte.toggleWorldWrapX(false)
	mte.toggleWorldWrapY(false)
	mte.loadMap("levels/level1.tmx") 
	mte.drawObjects()
	map = mte.setCamera({levelPosX = 0, levelPosY = 0, blockScale = 40})
	mte.constrainCamera()

	-- LOAD CHARS: --------------------------------------------------------
	player1 = loadplayer1()
	player1.name = player1Name
	player1.collision = test
	player1:addEventListener("collision")
	
	--[[
	player2 = loadplayer2()
	player2.name = player2Name

	player3 = loadplayer3()
	player3.name = player3Name
	]]--

	-- INSERT LEFT DPAD: -------------------------------------------------------
	local leftdpad = {}

	leftdpad[1] = display.newImage("sprites/button.png")
	leftdpad[1].x = 10
	leftdpad[1].y = 245
	leftdpad[1].width = 45
	leftdpad[1].height = 31
	leftdpad[1].myName = "up"
	leftdpad[1].rotation = -90

	leftdpad[2] = display.newImage("sprites/button.png")
	leftdpad[2].x = 10
	leftdpad[2].y = 291
	leftdpad[2].width = 45
	leftdpad[2].height = 31
	leftdpad[2].myName = "down"
	leftdpad[2].rotation = 90

	leftdpad[3] = display.newImage("sprites/button.png")
	leftdpad[3].x = -12
	leftdpad[3].y = 268,5
	leftdpad[3].width = 45
	leftdpad[3].height = 31
	leftdpad[3].myName = "left"
	leftdpad[3].rotation = 180

	leftdpad[4] = display.newImage("sprites/button.png")
	leftdpad[4].x = 32
	leftdpad[4].y = 268,5
	leftdpad[4].width = 45
	leftdpad[4].height = 31
	leftdpad[4].myName = "right"


	-- INSERT RIGHT DPAD: -------------------------------------------------------
	local rightdpad = {}

	rightdpad[1] = display.newImage("sprites/button.png")
	rightdpad[1].x = 460
	rightdpad[1].y = 245
	rightdpad[1].width = 45
	rightdpad[1].height = 31
	rightdpad[1].myName = "up"
	rightdpad[1].rotation = -90

	rightdpad[2] = display.newImage("sprites/button.png")
	rightdpad[2].x = 460
	rightdpad[2].y = 291
	rightdpad[2].width = 45
	rightdpad[2].height = 31
	rightdpad[2].myName = "down"
	rightdpad[2].rotation = 90

	rightdpad[3] = display.newImage("sprites/button.png")
	rightdpad[3].x = 438
	rightdpad[3].y = 268,5
	rightdpad[3].width = 45
	rightdpad[3].height = 31
	rightdpad[3].myName = "left"
	rightdpad[3].rotation = 180

	rightdpad[4] = display.newImage("sprites/button.png")
	rightdpad[4].x = 482
	rightdpad[4].y = 268,5
	rightdpad[4].width = 45
	rightdpad[4].height = 31
	rightdpad[4].myName = "right"


	--all display objects must be inserted into group
	sceneGroup:insert( map )
	--sceneGroup:insert( player1 )
	--sceneGroup:insert( player2 )
	--sceneGroup:insert( player3 )
	sceneGroup:insert( leftdpad[1] )
	sceneGroup:insert( leftdpad[2] )
	sceneGroup:insert( leftdpad[3] )
	sceneGroup:insert( leftdpad[4] )
	sceneGroup:insert( rightdpad[1] )
	sceneGroup:insert( rightdpad[2] )
	sceneGroup:insert( rightdpad[3] )
	sceneGroup:insert( rightdpad[4] )


local j=1

for j=1, #leftdpad do 
	leftdpad[j]:addEventListener("touch", touchFunction)
end

for j=1, #rightdpad do 
	rightdpad[j]:addEventListener("touch", RotationFunction)
end

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen 
		-- e.g. start timers, begin animation, play audio, etc.
		mte.physics.start()
		audio.play( soundTable["music"], {loops=-1})
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
    local currentChar = player1
	currentChar.x = currentChar.x + xAxis
	currentChar.y = currentChar.y + yAxis
end
    

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "enterFrame", update )

-----------------------------------------------------------------------------------------

return scene