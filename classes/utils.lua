module (..., package.seeall)

local composer = require( "composer" )

-- Importando arquivos necessários pro jogo:
local sounds = require('libs.sounds')

currentWeapon = "rifle"

function getCurrentWeapon(cw)
	currentWeapon = cw
	if (currentWeapon ~= "nil") then
		print("currentWeapon: " .. currentWeapon)
	else
		print("currentWeapon nula")
	end
end

function getShootSpeed()

	if (currentWeapon == "handgun") then
		return 300
	end
	if (currentWeapon == "rifle") then
		return 100
	end
	if (currentWeapon == "shotgun") then
		return 1000
	end
end


function shoot()

	if (currentWeapon == "handgun") then
		handgunShoot()
	end
	if (currentWeapon == "rifle") then
		rifleShoot()
	end
	if (currentWeapon == "shotgun") then
		shotgunShoot()
	end
end

function die()
	local background = display.newImageRect( "images/gameOver.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	sounds.stop()
	sounds.playStream("lose")
end