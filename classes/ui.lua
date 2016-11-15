-- ui.lua

-- include Corona's "widget" library
local widget = require "widget"

-- Importando arquivos necessários pro jogo:
local sounds = require('libs.sounds')

local loader = require("classes.loader")

local screenLeft = display.screenOriginX
local screenTop = display.screenOriginY

local ui = {}

-----------------------------------------------------

function ui.loadUi()

	---------------------------------------------------------
	-- Textos de Debug:
	---------------------------------------------------------

	--textScore = display.newText("Score: "..score, 10, 10, nil, 12)
	--textWave = display.newText ("Level: "..waveProgress, 10, 30, nil, 12)
	--textBullets = display.newText ("Bullets: "..numBullets, 10, 50, nil, 12)

	-- create red health bar
	healthBarRed = display.newRect(70, 21, 200, 17)
	healthBarRed:setFillColor( 255/255, 0/255, 0/255 )

    
    -- create orange health bar
	healthBarOrange = display.newRect(70, 21, 200, 17)
	healthBarOrange:setFillColor( 255/255, 140/255, 0/255 )

    --healthBarOrange.width = healthBarOrange.width - 100
    --healthBarOrange.x = healthBarOrange.x - 50
    
    -- create green health bar
	healthBarGreen = display.newRect(70, 21, 200, 17)
	healthBarGreen:setFillColor( 0/255, 255/255, 0/255 )

    --healthBarGreen.width = healthBarOrange.width - 50

	-- create red damage bar (-create it second so it lays on top)
	--damageBar = display.newRect(70, 21, 30, 17)
	--damageBar:setFillColor( 255/255, 0/255, 0/255 )
	
	healthBarImg = display.newImage("images/ui/Healthbar.png", 70, 20)
	healthBarImg.xScale = 0.70
	healthBarImg.yScale = 0.70

	---------------------------------------------------------
	-- Background da caixa de weapons:
	---------------------------------------------------------

	weaponsBack = display.newImage( "images/ui/weaponsBack.png", 410, 39)
	weaponsBack.xScale = 0.2
	weaponsBack.yScale = 0.2

	---------------------------------------------------------
	-- Load Weapons:
	---------------------------------------------------------

	local spriteSheet = graphics.newImageSheet("images/sprites/weapons/weapons.png", {width = 130, height = 45, numFrames = 3})
	local sequenceData = {		
		{name = "rifle", frames = {1}},
		{name = "shotgun", frames = {2}},
		{name = "handgun", frames = {3}}
	}
	local weapons = display.newSprite(spriteSheet, sequenceData)
	weapons.x = 410
	weapons.y = 52
	weapons.xScale = 0.8
	weapons.yScale = 0.8
	weapons:setSequence( "handgun" )

	----------------------------------------------------------
	-- Seta da esquerda:
	----------------------------------------------------------

	leftArrow = widget.newButton({
		defaultFile  = "images/ui/backward.png",
		--overFile = "images/ui/btnStartHover.png",
		width=50, height=50,
		onRelease = function()
			sounds.play('tap')
			weapons:setSequence("shotgun")
		end
	})

	leftArrow.x = 320
	leftArrow.y = 39

	---------------------------------------------------------
	-- Seta da direita:
	---------------------------------------------------------

	rightArrow = widget.newButton({
		defaultFile  = "images/ui/forward.png",
		--overFile = "images/ui/btnStartHover.png",
		width=50, height=50,
		onRelease = function()
			sounds.play('tap')
			weapons:setSequence("rifle")
		end
	})

	rightArrow.x = 500
	rightArrow.y = 39

	---------------------------------------------------------
	-- Background Blood Image:
	---------------------------------------------------------
--	
--	bloodSplash = display.newImageRect( "images/ui/blood.png", display.actualContentWidth, display.actualContentHeight )
--	bloodSplash.anchorX = 0
--	bloodSplash.anchorY = 0
--	bloodSplash.x = 0 + display.screenOriginX 
--	bloodSplash.y = 0 + display.screenOriginY
	
end


function ui.updateHealthBar(damageTaken)
	if (healthBarGreen.width > 0) then
		healthBarGreen.width = healthBarGreen.width - damageTaken
		healthBarGreen.x = healthBarGreen.x - damageTaken/2
	elseif (healthBarOrange.width > 0) then
		healthBarOrange.width = healthBarOrange.width - damageTaken
		healthBarOrange.x = healthBarOrange.x - damageTaken/2
	else
		healthBarRed.width = healthBarRed.width - damageTaken
		healthBarRed.x = healthBarRed.x - damageTaken/2
	end
end

return ui