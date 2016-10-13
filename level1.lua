local composer = require( "composer" )
local scene = composer.newScene()

-- Importando a biblioteca MTE:
local mte = require("MTE.mte").createMTE()

-- Importando a biblioteca dos joysticks:
local StickLib   = require("joystick.lib_analog_stick")

-- Variaveis usadas no pathfinder:
local Grid = require ("jumper.grid")
local Pathfinder = require ("jumper.pathfinder")

display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "magTextureFilter", "nearest" )
display.setDefault( "minTextureFilter", "nearest" )
system.activate("multitouch")

-- Declaração de variaveis locais da tela e posições iniciais:
local screenW, screenH = display.actualContentWidth, display.actualContentHeight
local Text = display.newText( " ", screenW*.6, screenH-20, native.systemFont, 15 )
local posX = display.contentWidth/2
local posY = display.contentHeight/2

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.contentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.contentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight

local mRandom = math.random
local mFloor = math.floor

-- variavel para inserir os inimigos e o player:
local enemies = display.newGroup()
local player

-- Variaveis globais:
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

local sqWidth = 16 -- OBS: Mesmo valor do blockscale
local sqHeight = 16 -- OBS: Mesmo valor do blockscale

-- funções globais:
local shoot
local goMapping

-- nomes das colisões:
local playerName = "player"
local zombiesName = "zombies"

-- Carregando as musicas e efeitos sonoros:
soundTable = {
	backgroundsnd = audio.loadStream( "sounds/backmusic.ogg" ),
	shot = audio.loadSound("sounds/pistol.wav"),
	noarmor = audio.loadSound("sounds/outofammo.wav")
}


-- Mapa da fase usada no pathfinder:
-- 0 = área que pode andar; 1 = área que não pode andar.
local map = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 4, 4, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
      }

--==============================================================
-- JUMPER SETUP
--==============================================================

local walkable = 0
	
local grid = Grid(map)
local pather = Pathfinder(grid, 'JPS', walkable)
local mode = "DIAGONAL" -- DIAGONAL  ORTHOGONAL
pather:setMode(mode)

--==============================================================
-- FUNÇÕES UTILITÁRIAS DO JUMPER
--==============================================================

-- pass in pixel coords and get back the grid coords
-- as a table: {x=n, y=n}
local function gridXYFromPixelXY(x,y)
	local pos = {}
	pos.x = mFloor((x)/sqWidth) + 1
	pos.y = mFloor((y)/sqHeight) + 1
	return pos
end

-- pass in grid coords and get back pixel pos for 
-- center of that square as a table: {x=n, y=n}
local function pixelXYFromGridXY(x,y)
	local pos = {}
	pos.x = mFloor((x)*sqWidth) - sqWidth/2
	pos.y = mFloor((y)*sqHeight) - sqHeight/2
	return pos
end

--==============================================================
-- mover o obj de ponto a ponto, seguindo o 
-- caminho retornado pelo Jumper.
--==============================================================

local function followPath(obj)
	if obj.idx < #obj.myPath + 1 then
		-- if goal has moved, find the new path
		if obj.targetX ~= player.xGrid or obj.targetY ~= player.yGrid then
			obj.targetX = player.xGrid
			obj.targetY = player.yGrid
			goMapping(obj, {x=obj.myPath[obj.idx].x, y=obj.myPath[obj.idx].y}, {x=player.xGrid, y=player.yGrid})
			obj.idx = 1
		end
		local pos = pixelXYFromGridXY(obj.myPath[obj.idx].x, obj.myPath[obj.idx].y)
		transition.to(obj, {time=obj.speed, x=pos.x, y=pos.y, onComplete=followPath})
		obj.idx = obj.idx + 1
	else
		display.remove( obj )
	end
end

--==============================================================
-- Código do jumper que encontra o melhor caminho
-- para o obj de startPos até endPos.
--==============================================================

function goMapping(obj, startPos, endPos)
	local sx,sy = startPos.x, startPos.y
	local ex,ey = endPos.x, endPos.y
	
	local path = pather:getPath(sx,sy, ex,ey)
	if path then
		if mode == "DIAGONAL" then
			path:fill()
		end
		obj.targetX = player.xGrid
		obj.targetY = player.yGrid
		local pNodes = path:nodes()
		obj.myPath = {}
		for node, count in pNodes do
			local xPos, yPos = node:getPos()
			obj.myPath[#obj.myPath+1] = {x=xPos, y=yPos}
		end
		obj.idx = 2 -- start with the next step
	else
	    print(('Path from [%d,%d] to [%d,%d] was : not found!'):format(sx,sy,ex,ey))
	end  
end

--==============================================================
-- Carregar o player e o zumbi:
--==============================================================

-- PLAYER:
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

-- ZUMBI:
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
		layer = 2,
		locX = 30,
		locY = 5,
		levelWidth = 38,
		levelHeight = 46
	}
	mte.physics.addBody( zombie, "dynamic" )
	mte.addSprite(zombie, setup)
	return zombie
end

local function makeZombies()
	local xGrid = mRandom(1,30)
	local yGrid = mRandom(1,30)
	local zumbi = display.newImage("sprites/zombie.png")

	local pos = pixelXYFromGridXY(xGrid,yGrid)
	zumbi.x = pos.x
	zumbi.y = pos.y
	zumbi.speed = mRandom(300, 500)
	goMapping(zumbi, {x=xGrid, y=yGrid}, {x=player.xGrid, y=player.yGrid})
	if #zumbi.myPath > 0 then
		followPath(zumbi)
	end
end

--==============================================================
-- SETAR O ANALÓGICO ESQUERDO: 
--==============================================================

function LeftStick( event )
	
    LeftStick:move(player, 5, false) -- se a opção for true o objeto se move com o joystick
	
	print("LeftStick:getAngle = "..LeftStick:getAngle())
	print("LeftStick:getDistance = "..LeftStick:getDistance())
	-- print("LeftStick:getPercent = "..LeftStick:getPercent()*100)
	print("POSICAO X / Y  " ..player.x,player.y)
	
end

--==============================================================
-- SETAR O ANALÓGICO DIREITO:
--==============================================================

function RightStick( event )

	distance = RightStick:getDistance()

	-- SHOW STICK INFO
    Text.text = "ANGLE = "..RightStick:getAngle().."   DIST = "..math.ceil(RightStick:getDistance()).."   PERCENT = "..math.ceil(RightStick:getPercent()*100).."%"

	RightStick:rotate(player, true)
	if(distance >= 16) then
		numBullets = numBullets - 1
		print("fire!")
	end

end

--==============================================================
-- Função de atirar:
--==============================================================

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

--=============================================================
-- COLISÃO ENTRE OS ZUMBIS E AS BALAS:
--=============================================================

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

-- ===================================================================================================================================

function scene:create( event )
	local sceneGroup = self.view

	--=======================================
	-- ABILITAR A FÍSICA: 
	--=======================================

	mte.enableBox2DPhysics()
	mte.physics.start()
	mte.physics.setGravity(0,0)
	--mte.physics.setDrawMode("hybrid")

	--=======================================
	-- CARREGAR MAPA:
	--=======================================

	mte.toggleWorldWrapX(false)
	mte.toggleWorldWrapY(false)
	mte.loadMap("levels/level1.tmx") 
	mte.drawObjects()
	map = mte.setCamera({levelPosX = centerX, levelPosY = halfH, blockScale = 40})
	mte.constrainCamera()

	--=======================================
	-- CARREGAR UI:
	--=======================================

	textScore = display.newText("Score: "..score, 10, 10, nil, 12)
	textWave = display.newText ("Level: "..waveProgress, 10, 30, nil, 12)
	textBullets = display.newText ("Bullets: "..numBullets, 10, 50, nil, 12)

	--=======================================
	-- CARREGAR PLAYER:
	--=======================================

	player = loadplayer()
	player.myName = playerName

	--=======================================
	-- CARREGAR ZUMBIS:
	--=======================================

	zombie = loadZombie()
	zombie.myName = zombiesName
	--timer.performWithDelay ( 500, makeZombies, 5 )

	--=======================================
	-- CARREGAR JOYSTICK:
	--=======================================

	local localGroup = display.newGroup()
	 	motionx = 0;
	 	motiony = 0;
	 	speed = 2;

	-- CRIAR O ANALÓGICO ESQUERDO:
	LeftStick = StickLib.NewLeftStick( 
        {
        x             = 17,
        y             = 260,
        thumbSize     = 5,
        borderSize    = 32, 
        snapBackSpeed = .2, 
        R             = 25,
        G             = 255,
        B             = 255
        } )
	
	-- CRIAR O ANALÓGICO DIREITO:
	RightStick = StickLib.NewRightStick( 
        {
        x             = 465,
        y             = 260,
        thumbSize     = 5,
        borderSize    = 32, 
        snapBackSpeed = .2, 
        R             = 25,
        G             = 255,
        B             = 255
        } )	

	--========================================
	-- INSERINDO ELEMENTOS NO GRUPO:
	--========================================

	sceneGroup:insert( map )
	sceneGroup:insert( textScore )
	sceneGroup:insert( textWave )
	sceneGroup:insert( textBullets )
	sceneGroup:insert( LeftStick )
	sceneGroup:insert( RightStick )

	

end

-- ======================================================================================================================================

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen 

		mte.physics.start()
		audio.play( soundTable["backgroundsnd"], {loops=-1})

		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen

		mte.physics.stop()

		-- e.g. stop timers, stop animation, unload sounds, etc.)
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
    

--========================================================================================

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "enterFrame", update )
Runtime:addEventListener( "enterFrame", LeftStick )
Runtime:addEventListener( "enterFrame", RightStick )
Runtime:addEventListener( "collision" , onCollision)

--========================================================================================

return scene