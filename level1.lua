local composer = require( "composer" )
local scene = composer.newScene()
local mte = require("MTE.mte").createMTE()

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "magTextureFilter", "nearest" )
display.setDefault( "minTextureFilter", "nearest" )
system.activate("multitouch")

-- variavel para inserir os inimigos:
local enemies = display.newGroup()

-- player and zombies declarations:
local player1, player2, player3, zombies
local yAxis, xAxis = 0, 0

-- player declarations:
local player1, player2, player3
local yAxis, xAxis = 0, 0
local currentChar

-- global variables:
local gameActive = true
local waveProgress = 1
local numHit = 0
local shootbtn
local numEnemy = 0
local enemyArray = {}
local onCollision
local score = 0
local gameovertxt
local numBullets = 20

-- global functions
local removeEnemies
local createGame
local createEnemy
local shoot
local newGame
local gameOver
local nextWave
local checkforProgress

-- collision names:
local player1Name = "player1"
local player2Name = "player2"
local player3Name = "player3"
local zombiesName = "zombies"

-- Left e Right DPAD:
local leftdpad = {}
local rightdpad = {}

-- Load the music of the game:
soundTable = {
	backgroundsnd = audio.loadStream( "sounds/dark_fallout.ogg" ),
	shot = audio.loadSound ("sounds/pistol.wav"),
	wavesnd = audio.loadSound ("sounds/wave.mp3")
}

-- Functions to setup chars and the zombie:
-- PLAYER 1: --------------------------------------------
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

-- ZOMBIE: -----------------------------------------------------
local loadZombie = function ()
    
	local spriteSheet = graphics.newImageSheet("sprites/zombie.png", {width = 35, height = 43, numFrames = 1})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  frames = {1}, time = 400},
		{name = "down", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "left", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "up", sheet = spriteSheet, frames = {1}, time = 400}
	}
	local zombie = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 3, 
		locX = 5,
		locY = 5,
		levelWidth = 15,
		levelHeight = 23
	}
	mte.physics.addBody( zombie, "dynamic" )
	mte.addSprite(zombie, setup)
	return zombie
end

-- Função de movimentação do personagem (Analog esquerdo) --------------------------------
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

-- Função de mira do personagem (Analog direito) -----------------------------------------
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

-- Create shot: -------------------------------------------------------------------------
function shoot(e)
	local eventName = e.phase
	local direction = e.target.myName
	local currentChar = player1
		
	if eventName == "began" or eventName == "moved" then	
		if (numBullets ~= 0) then
			--numBullets = numBullets - 1
			local bullet = display.newImage("sprites/bullet.png")
			physics.addBody(bullet, "static", {density = 1, friction = 0, bounce = 0});
			bullet.xScale = 0.5
			bullet.yScale = 0.5 
			bullet.myName = "bullet"
			textBullets.text = "Bullets "..numBullets

			startlocationX = currentChar.x
			startlocationY = currentChar.y

			if (currentChar.rotation == 0) then
				bullet.rotation = 0
				bullet.x = screenW/2-40 
				bullet.y = screenH/2-60
				transition.to ( bullet, { time = 1000, x = screenW/2-40, y = screenH-700} )
			elseif (currentChar.rotation == 180) then
				bullet.rotation = 180
				bullet.x = screenW/2-48 
				bullet.y = screenH/2+60
				transition.to ( bullet, { time = 1000, x = screenW/2-48, y = screenH+500} )
			elseif (currentChar.rotation == 90) then
				bullet.rotation = 90
				bullet.x = screenW/2+10
				bullet.y = screenH/2+5
				transition.to ( bullet, { time = 1000, x = screenW+200, y = screenH/2+5} )
			elseif (currentChar.rotation == -90) then
				bullet.rotation = -90
				bullet.x = screenW/2-100 
				bullet.y = screenH/2-5
				transition.to ( bullet, { time = 1000, x = -300, y = screenH/2-5} )
			end
			audio.play(soundTable["shot"])

		end 
	end
end

-- Collision: ---------------------------------------------------------------------------
function onCollision(event)
	currentChar = player1
 
	if((event.object1.myName=="zombies" and event.object2.myName=="bullet") or 
		(event.object1.myName=="bullet" and event.object2.myName=="zombies")) then
		event.object1:removeSelf()
		event.object1.myName=nil
		event.object2:removeSelf()
		event.object2.myName=nil
		score = score + 10
		textScore.text = "Score: "..score
		numHit = numHit + 1
		print ("numhit "..numHit)
	end
end

--[[
function removeEnemies()
	for i =1, #enemyArray do
		if (enemyArray[i].myName ~= nil) then
			enemyArray[i]:removeSelf()
			enemyArray[i].myName = nil
			print("enemies removed!")
		end
	end
end


function nextWave (event)
	display.remove(event.target)
	numHit = 0
	gameActive = true 
end

local function checkforProgress()
	if numHit == waveProgress then
		gameActive = false
		audio.play(wavesnd)
		removeEnemies()
		waveTxt = display.newText(  "Level "..waveProgress.. " Completed", cWidth-80, cHeight-100, nil, 20 )
		waveProgress = waveProgress + 1
		textWave.text = "Level: "..waveProgress
		print("wavenumber "..waveProgress)
		waveTxt:addEventListener("tap",  nextWave)
	end

	-- remove enemies which are not shot
	for i =1, #enemyArray do
		if (enemyArray[i].myName ~= nil) then
			if(enemyArray[i].y > display.contentHeight) then
			    enemyArray[i]:removeSelf()
			    enemyArray[i].myName = nil
				score = score - 20 
				textScore.text = "Score: "..score
				warningTxt = display.newText(  "Watch out!", cWidth-42, ship.y-50, nil, 12 )
				local function showWarning()
					display.remove(warningTxt)
				end
				timer.performWithDelay(1000, showWarning)
				print("cleared")
			end
		end
	end
end
]]--

function scene:create( event )
	local sceneGroup = self.view

	-- ENABLE PHYSICS: ----------------------------------------------------
	mte.enableBox2DPhysics()
	mte.physics.start()
	mte.physics.setGravity(0,0)
	--mte.physics.setDrawMode("hybrid")

	-- LOAD MAP: ----------------------------------------------------------
	mte.toggleWorldWrapX(false)
	mte.toggleWorldWrapY(false)
	mte.loadMap("levels/level1.tmx") 
	mte.drawObjects()
	map = mte.setCamera({levelPosX = 0, levelPosY = 0, blockScale = 30})
	map = mte.setCamera({levelPosX = 0, levelPosY = 0, blockScale = 40})
	mte.constrainCamera()

	-- LOAD UI: -----------------------------------------------------------
	textScore = display.newText("Score: "..score, 10, 10, nil, 12)
	textWave = display.newText ("Level: "..waveProgress, 10, 30, nil, 12)
	textBullets = display.newText ("Bullets: "..numBullets, 10, 50, nil, 12)

	-- LOAD CHARS: --------------------------------------------------------
	player1 = loadplayer1()
	player1.myName = player1Name
	--player1:addEventListener("collision")

	-- LOAD ZOMBIES: ------------------------------------------------------
	enemies:toFront()
	for i=1,20 do
		enemyArray[i] = loadZombie()
		enemyArray[i].myName = zombiesName
		startlocationX = math.random (0, player1.x + 10)
		enemyArray[i].x = startlocationX
		startlocationY = math.random (0, player1.y + 10)
		enemyArray[i].y = startlocationY

		transition.to ( enemyArray[i] , { time = math.random (12000, 20000), x= math.random (0, display.contentWidth ), y=player1.y-500 } )
		enemies:insert(enemyArray[i] )		
	end

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

	sceneGroup:insert( leftdpad[1] )
	sceneGroup:insert( leftdpad[2] )
	sceneGroup:insert( leftdpad[3] )
	sceneGroup:insert( leftdpad[4] )
	sceneGroup:insert( rightdpad[1] )
	sceneGroup:insert( rightdpad[2] )
	sceneGroup:insert( rightdpad[3] )
	sceneGroup:insert( rightdpad[4] )

	
	for i=1,20 do
		sceneGroup:insert( enemyArray[i] )	
	end


local j=1

for j=1, #leftdpad do 
	leftdpad[j]:addEventListener("touch", touchFunction)
end

for j=1, #rightdpad do 
	rightdpad[j]:addEventListener("touch", RotationFunction)
end

for j=1, #rightdpad do 
	rightdpad[j]:addEventListener("touch", shoot)
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
		audio.play( soundTable["backgroundsnd"], {loops=-1})
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
Runtime:addEventListener( "collision" , onCollision)

-----------------------------------------------------------------------------------------

return scene