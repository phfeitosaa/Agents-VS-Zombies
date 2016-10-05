local composer = require( "composer" )
local scene = composer.newScene()
local mte = require("MTE.mte").createMTE()
local StickLib   = require("joystick.lib_analog_stick")

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local Text = display.newText( " ", screenW*.6, screenH-20, native.systemFont, 15 )
local posX = display.contentWidth/2
local posY = display.contentHeight/2

display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "magTextureFilter", "nearest" )
display.setDefault( "minTextureFilter", "nearest" )
system.activate("multitouch")

-- variavel para inserir os inimigos e o player:
local enemies = display.newGroup()
local player

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
local numZombies = 20

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
local playerName = "player"
local zombiesName = "zombies"


-- Load the music of the game:
soundTable = {
	backgroundsnd = audio.loadStream( "sounds/backmusic.ogg" ),
	shot = audio.loadSound("sounds/pistol.wav"),
	noarmor = audio.loadSound("sounds/outofammo.wav")
}

-- Functions to setup chars and the zombie:
-- PLAYER 1: ------------------------------------------------------------------------------
local loadplayer = function ()
    
	local spriteSheet = graphics.newImageSheet("sprites/player1_gun.png", {width = 48, height = 48, numFrames = 1})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  frames = {1}, time = 400},
		{name = "down", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "left", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "up", sheet = spriteSheet, frames = {1}, time = 400}
	}
	local player = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 2, 
		locX = 15,
		locY = 10,
		levelWidth = 48,
		levelHeight = 48
	}
	mte.physics.addBody( player, "dynamic" )
	mte.addSprite(player, setup)
	mte.setCameraFocus(player)
	return player
end

-- ZOMBIE: -------------------------------------------------------------------------------
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
		layer = 1,
		locX = math.random(0, 20),
		locY = math.random(0, 20),
		levelWidth = 22,
		levelHeight = 30
	}
	mte.physics.addBody( zombie, "dynamic" )
	mte.addSprite(zombie, setup)
	return zombie
end

-- Create shot: -------------------------------------------------------------------------
function shoot()
	if (numBullets ~= 0) then
		timer.performWithDelay(1000)
		audio.play(soundTable["shot"])
		--numBullets = numBullets - 1
		local bullet = display.newImage("sprites/bullet.png")
		physics.addBody(bullet, "static", {density = 1, friction = 0, bounce = 0});
		bullet.xScale = 0.5
		bullet.yScale = 0.5 
		bullet.myName = "bullet"
		textBullets.text = "Bullets "..numBullets
	else
		audio.play(soundTable["noarmor"])
	end 

end

-- 
function LeftStick( event )
	
	-- MOVE THE CHAR:
    LeftStick:move(player, 5, false) -- se a opção for true o objeto se move com o joystick

    -- -- SHOW STICK INFO
    -- Text.text = "ANGLE = "..LeftStick:getAngle().."   DIST = "..math.ceil(LeftStick:getDistance()).."   PERCENT = "..math.ceil(LeftStick:getPercent()*100).."%"
	
	print("LeftStick:getAngle = "..LeftStick:getAngle())
	print("LeftStick:getDistance = "..LeftStick:getDistance())
	-- print("LeftStick:getPercent = "..LeftStick:getPercent()*100)
	print("POSICAO X / Y  " ..player.x,player.y)
	
	angle = LeftStick:getAngle() 
	moving = LeftStick:getMoving()
	
	--If the analog stick is moving, animate the sprite
	if(moving) then 
		player:play() 
	end
end

function RightStick( event )

	distance = RightStick:getDistance()

	RightStick:rotate(player, true)
	if(distance >= 16) then
		--shoot()
		print("fire!")
	end

end

-- Collision: ---------------------------------------------------------------------------
function onCollision(event)
	player = player
 
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
	map = mte.setCamera({levelPosX = halfW, levelPosY = halfH, blockScale = 40})
	mte.constrainCamera()

	-- LOAD UI: -----------------------------------------------------------
	textScore = display.newText("Score: "..score, 10, 10, nil, 12)
	textWave = display.newText ("Level: "..waveProgress, 10, 30, nil, 12)
	textBullets = display.newText ("Bullets: "..numBullets, 10, 50, nil, 12)

	-- LOAD PLAYER: --------------------------------------------------------
	player = loadplayer()
	player.myName = playerName

	-- LOAD JOYSTICKS: -----------------------------------------------------
	local localGroup = display.newGroup() -- remember this for farther down in the code
	 	motionx = 0; -- Variable used to move character along x axis
	 	motiony = 0; -- Variable used to move character along y axis
	 	speed = 2; -- Set Walking Speed 

	-- CREATE RIGHT ANALOG STICK
	LeftStick = StickLib.NewLeftStick( 
        {
        x             = 30,
        y             = 250,
        thumbSize     = 5,
        borderSize    = 32, 
        snapBackSpeed = .2, 
        R             = 25,
        G             = 255,
        B             = 255
        } )
	
	RightStick = StickLib.NewRightStick( 
        {
        x             = 450,
        y             = 250,
        thumbSize     = 5,
        borderSize    = 32, 
        snapBackSpeed = .2, 
        R             = 25,
        G             = 255,
        B             = 255
        } )	

	-- LOAD ZOMBIES: ------------------------------------------------------
	--[[
	enemies:toFront()
	for i=1,numZombies do
		enemyArray[i] = loadZombie()
		enemyArray[i].myName = zombiesName

		--transitionTo()
		--mte.moveSpriteTo({sprite = enemyArray[i], locX = player.x, locY = player.y, time = 30, transition = easing.inQuad})
		enemies:insert(enemyArray[i] )		
	end
	]]--

	--all display objects must be inserted into group
	sceneGroup:insert( map )
	sceneGroup:insert( textScore )
	sceneGroup:insert( textWave )
	sceneGroup:insert( textBullets )
	sceneGroup:insert( LeftStick )
	sceneGroup:insert( RightStick )
	
	--[[
	for i=1,20 do
		sceneGroup:insert( enemyArray[i] )	
	end
	]]--
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
Runtime:addEventListener( "enterFrame", update )
Runtime:addEventListener( "enterFrame", LeftStick )
Runtime:addEventListener( "enterFrame", RightStick )
Runtime:addEventListener( "collision" , onCollision)

-----------------------------------------------------------------------------------------

return scene