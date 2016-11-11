------------------------------------------------------------------------------

-- Aqui encontra-se todas as armas e suas respectivas funções e atributos.

local sounds = require('libs.sounds')

-------------------------------------------------------------------------------

local weapons = {}

local currentWeapon

local handgun = {}
local rifle = {}
local shotgun = {}

local damage = 0
local numBulletsMax = 0
local numBulletsActual = 0

-- Atributos da handgun:
handgun.damage = 10
handgun.numBulletsMax = 60
handgun.numBulletsActual = 60

-- Atributos do rifle:
rifle.damage = 20
rifle.numBulletsMax = 200
rifle.numBulletsActual = 200

-- Atributos da shotgun:
shotgun.damage = 50
shotgun.numBulletsMax = 30
shotgun.numBulletsActual = 30

--==============================================================
-- Funções de atirar:
--==============================================================

currentWeapon = shotgun

function weapons.getShootSpeed()
	if (currentWeapon == handgun) then
		return 400
	end
	if (currentWeapon == rifle) then
		return 100
	end
	if (currentWeapon == shotgun) then
		return 800
	end
end

function weapons.shoot()

	if (currentWeapon == handgun) then
		weapons.handgunShoot()
	end
	if (currentWeapon == rifle) then
		weapons.rifleShoot()
	end
	if (currentWeapon == shotgun) then
		weapons.shotgunShoot()
	end
end

function weapons.handgunShoot()

	if handgun.numBulletsActual > 0 then
		sounds.play('pistol')
		handgun.numBulletsActual = handgun.numBulletsActual - 1
		print(handgun.numBulletsActual)
		
	elseif handgun.numBulletsActual == 0 then
		sounds.play('noAmmo')
	end

end

function weapons.rifleShoot()
	if rifle.numBulletsActual > 0 then
		sounds.play('pistol')
		rifle.numBulletsActual = rifle.numBulletsActual - 1
		print(rifle.numBulletsActual)
		
	elseif rifle.numBulletsActual == 0 then
		sounds.play('noAmmo')
	end
end

function weapons.shotgunShoot()
	if handgun.numBulletsActual > 0 then
		sounds.play('pistol')
		handgun.numBulletsActual = handgun.numBulletsActual - 1
		print(handgun.numBulletsActual)
		
	elseif handgun.numBulletsActual == 0 then
		sounds.play('noAmmo')
	end
end

return weapons