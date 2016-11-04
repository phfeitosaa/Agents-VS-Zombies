-- ui.lua

-- include Corona's "widget" library
local widget = require "widget"

-- Importando arquivos necessários pro jogo:
local sounds = require('libs.sounds')

local loader = require("classes.loader")

local ui = {}

-----------------------------------------------------

ui.loadUi = function()

	---------------------------------------------------------
	-- Textos de Debug:
	---------------------------------------------------------

	--textScore = display.newText("Score: "..score, 10, 10, nil, 12)
	--textWave = display.newText ("Level: "..waveProgress, 10, 30, nil, 12)
	--textBullets = display.newText ("Bullets: "..numBullets, 10, 50, nil, 12)


	hpBar = display.newImage("images/ui/Healthbar.png", 70, 20)
	hpBar.xScale = 0.8
	hpBar.yScale = 0.8

	--hpBarRect = display.newRect(30, 30, 50, 50)
	--hpBarRect:setFillColor( red )
	
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

	

end

return ui