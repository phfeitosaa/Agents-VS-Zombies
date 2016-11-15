
local utils = {}

local currentWeapon = "handgun"

function utils.getShootSpeed()

	if (currentWeapon == "handgun") then
		return 300
	end
	if (currentWeapon == "rifle") then
		return 80
	end
	if (currentWeapon == "shotgun") then
		return 1000
	end
end


function utils.shoot()

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


return utils