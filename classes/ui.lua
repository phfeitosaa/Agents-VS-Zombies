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

	--=================================================================

	-- Health Bar Inicio:

	--=================================================================

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

	weapon1Back = display.newImage( "images/ui/weaponsBack.png", 310, 39)
	weapon1Back.xScale = 0.2
	weapon1Back.yScale = 0.2

	weapon2Back = display.newImage( "images/ui/weaponsBack.png", 450, 39)
	weapon2Back.xScale = 0.2
	weapon2Back.yScale = 0.2

	---------------------------------------------------------
	-- Load Weapons:
	---------------------------------------------------------

	loader.newAssaultClass()
	
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