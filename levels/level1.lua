display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "magTextureFilter", "nearest" )
display.setDefault( "minTextureFilter", "nearest" )
system.activate("multitouch")

local composer = require( "composer" )
local scene = composer.newScene()

-- Importando a biblioteca MTE:
mte = require("libs.MTE.mte").createMTE()

-- Importando a biblioteca dos joysticks:
local StickLib = require("libs.lib_analog_stick")

-- Importando a biblioteca do pathfinder:
local Grid = require ("libs.jumper.grid")
local Pathfinder = require ("libs.jumper.pathfinder")

-- Importando arquivos necessários pro jogo:
local sounds = require('libs.sounds')
local loader = require("classes.loader")
local ui = require("classes.ui")

local shoot
local goMapping

local handgun

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

local player

-- Variaveis globais:
mRandom = math.random
mFloor = math.floor
gameActive = true
waveProgress = 1
numHit = 0
score = 0
numBullets = 20
numZombies1 = 40
numZombies2 = 20
numZombies3 = 10

local sqWidth = 62 -- OBS: Mesmo valor do blockscale
local sqHeight = 62 -- OBS: Mesmo valor do blockscale

-- nomes das colisões:
local playerName = "player"
local zombiesName = "zombies"
local BulletsName = "bullets"


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
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 4, 4, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
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
pather = Pathfinder(grid, 'BFS', walkable)
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

	player.xGrid = player.locX
	player.yGrid = player.locY

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
	
	player.xGrid = player.locX
	player.yGrid = player.locY

	local sx,sy = startPos.x, startPos.y
	local ex,ey = endPos.x, endPos.y
	
	local path = pather:getPath(sx,sy, ex,ey)
	if path then
		--[[
		if mode == "DIAGONAL" then
			path:fill()
		end
		]]
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


local function makeZombie1()

	player.xGrid = player.locX
	player.yGrid = player.locY

	local zombie1 = loader.newZombie1()
	local xGrid = zombie1.locX
	local yGrid = zombie1.locY

	zombie1.speed = 600
	goMapping(zombie1, {x=xGrid, y=yGrid}, {x=player.xGrid, y=player.yGrid})
	
	followPath(zombie1)
end

local function makeZombie2()

	player.xGrid = player.locX
	player.yGrid = player.locY

	local zombie2 = loader.newZombie2()
	local xGrid = zombie2.locX
	local yGrid = zombie2.locY

	zombie2.speed = 800
	goMapping(zombie2, {x=xGrid, y=yGrid}, {x=player.xGrid, y=player.yGrid})
	
	followPath(zombie2)
end

local function makeZombie3()

	player.xGrid = player.locX
	player.yGrid = player.locY

	local zombie3 = loader.newZombie3()
	local xGrid = zombie3.locX
	local yGrid = zombie3.locY

	zombie3.speed = 1000
	goMapping(zombie3, {x=xGrid, y=yGrid}, {x=player.xGrid, y=player.yGrid})
	
	followPath(zombie3)
end

local function makeZombieBoss()

	player.xGrid = player.locX
	player.yGrid = player.locY

	local zombieBoss = loader.newZombieBoss()
	local xGrid = zombieBoss.locX
	local yGrid = zombieBoss.locY

	zombieBoss.speed = 1200
	goMapping(zombieBoss, {x=xGrid, y=yGrid}, {x=player.xGrid, y=player.yGrid})
	
	followPath(zombieBoss)
end

--==============================================================
-- SETAR O ANALÓGICO ESQUERDO: 
--==============================================================

function LeftStick( event )
	
    LeftStick:move(player, 5, false) -- se a opção for true o objeto se move com o joystick
	
	--print("LeftStick:getAngle = "..LeftStick:getAngle())
	--print("LeftStick:getDistance = "..LeftStick:getDistance())
	--print("LeftStick:getPercent = "..LeftStick:getPercent()*100)
	--print("POSICAO X / Y  " ..player.x,player.y)
	
end

--==============================================================
-- SETAR O ANALÓGICO DIREITO:
--==============================================================

function RightStick( event )

	distance = RightStick:getDistance()

	-- SHOW STICK INFO
    Text.text = "ANGLE = "..RightStick:getAngle().."   DIST = "..math.ceil(RightStick:getDistance()).."   PERCENT = "..math.ceil(RightStick:getPercent()*100).."%"

	RightStick:rotate(player, true)
	RightStick:addEventListener("touch", shoot)
end


--==============================================================
-- Função de atirar:
--==============================================================

function shoot(event)
	if event.phase == "began" then
		if numBullets ~= 0 then
			timer.performWithDelay(500, sounds.atirar)
			numBullets = numBullets - 1
			print(numBullets)
			--local bullet = display.newImage("images/sprites/bullet.png")
			--physics.addBody(bullet, "static", {density = 1, friction = 0, bounce = 0});
			--bullet.xScale = 0.5
			--bullet.yScale = 0.5 
			--bullet.myName = "bullet"
		elseif numBullets == 0 then
			timer.performWithDelay(500, sounds.semBala)
		end
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
	mte.loadMap("maps/level1.tmx")
	mte.drawObjects()
	map = mte.setCamera({levelPosX = centerX, levelPosY = halfH, blockScale = 60})
	mte.constrainCamera()

	--=======================================
	-- CARREGAR UI:
	--=======================================

	ui.loadUi()

	--=======================================
	-- CARREGAR PLAYER:
	--=======================================

	player = loader.newPlayerHandgun()
	player.myName = playerName

	--=======================================
	-- CARREGAR zombieS:
	--=======================================

	timer.performWithDelay ( mRandom(500,1000), makeZombie1, numZombies1 )
	timer.performWithDelay ( mRandom(500,1000), makeZombie2, numZombies2 )
	timer.performWithDelay ( mRandom(500,1000), makeZombie3, numZombies3 )
	timer.performWithDelay ( mRandom(500,1000), makeZombieBoss, 1 )

	--=======================================
	-- CARREGAR JOYSTICK:
	--=======================================


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

	local circShoot = display.newCircle(465, 260, 50, 50)
	circShoot.isVisible = false
	circShoot:setFillColor( 0, 0, 0 )
	circShoot:addEventListener ( "touch", shoot )

	--========================================
	-- INSERINDO ELEMENTOS NO GRUPO:
	--========================================

	sceneGroup:insert( map )
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
		sounds.playStream('game_music')

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

--========================================================================================

return scene