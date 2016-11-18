-- loader.lua

local loader = {}

----------------------------------------------
-- playerHandgun:
----------------------------------------------

loader.newPlayer = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/player.png", {width = 47, height = 108, numFrames = 6})
	local sequenceData = {		
		{name = "handgun", sheet = spriteSheet,  frames = {1}, time = 100},
		{name = "handgunfire", sheet = spriteSheet, frames = {2}, time = 100},
		{name = "shotgun", sheet = spriteSheet, frames = {3}, time = 100},
		{name = "shotgunfire", sheet = spriteSheet, frames = {4}, time = 100},
		{name = "rifle", sheet = spriteSheet, frames = {5}, time = 100},
		{name = "riflefire", sheet = spriteSheet, frames = {6}, time = 100}
	}
	local player = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 2, 
		locX = 17,
		locY = 10
	}
	mte.physics.addBody( player, "dynamic" )
	mte.addSprite(player, setup)
	mte.setCameraFocus(player)
	return player
end

loader.newPlayerHandgun = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/handgun.png", {width = 45, height = 61, numFrames = 1})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  frames = {1}, time = 400},
		{name = "down", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "left", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "up", sheet = spriteSheet, frames = {1}, time = 400}
	}
	local playerHandgun = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 2, 
		locX = 17,
		locY = 10
	}
	mte.physics.addBody( playerHandgun, "dynamic" )
	mte.addSprite(playerHandgun, setup)
	mte.setCameraFocus(playerHandgun)
	return playerHandgun
end

----------------------------------------------
-- playerRifle:
----------------------------------------------

loader.newPlayerRifle = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/rifle.png", {width = 45, height = 76, numFrames = 1})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  frames = {1}, time = 400},
		{name = "down", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "left", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "up", sheet = spriteSheet, frames = {1}, time = 400}
	}
	local playerRifle = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 2, 
		locX = 17,
		locY = 10
	}
	mte.physics.addBody( playerRifle, "dynamic" )
	mte.addSprite(playerRifle, setup)
	mte.setCameraFocus(playerRifle)
	return playerRifle
end

---------------------------------------------
-- playerShotgun:
---------------------------------------------

loader.newPlayerShotgun = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/shotgun.png", {width = 45, height = 77, numFrames = 1})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  frames = {1}, time = 400},
		{name = "down", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "left", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "up", sheet = spriteSheet, frames = {1}, time = 400}
	}
	local playerShotgun = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 2, 
		locX = 17,
		locY = 10
	}
	mte.physics.addBody( playerShotgun, "dynamic" )
	mte.addSprite(playerShotgun, setup)
	mte.setCameraFocus(playerShotgun)
	return playerShotgun
end

---------------------------------------------
-- ZUMBI 1:
---------------------------------------------

loader.newZombie1 = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/zombie1.png", {width = 45, height = 51, numFrames = 1})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  frames = {1}, time = 400},
		{name = "down", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "left", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "up", sheet = spriteSheet, frames = {1}, time = 400}
	}
	local zombie1 = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 2,
		locX = mRandom(9,12),
		locY = 1
	}
	mte.physics.addBody( zombie1, "dynamic" )
	mte.addSprite(zombie1, setup)
	return zombie1
end

---------------------------------------------
-- ZUMBI 2:
---------------------------------------------

loader.newZombie2 = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/zombie2.png", {width = 45, height = 51, numFrames = 1})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  frames = {1}, time = 400},
		{name = "down", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "left", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "up", sheet = spriteSheet, frames = {1}, time = 400}
	}
	local zombie2 = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite",
		layer = 2,
		locX = 1,
		locY = mRandom(16,19),
		rotation = 90
	}
	mte.physics.addBody( zombie2, "dynamic" )
	mte.addSprite(zombie2, setup)
	return zombie2
end

---------------------------------------------
-- ZUMBI 3:
---------------------------------------------

loader.newZombie3 = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/zombie3.png", {width = 45, height = 51, numFrames = 1})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  frames = {1}, time = 400},
		{name = "down", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "left", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "up", sheet = spriteSheet, frames = {1}, time = 400}
	}
	local zombie3 = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 2,
		locX = mRandom(9,12),
		locY = 1
	}
	mte.physics.addBody( zombie3, "dynamic" )
	mte.addSprite(zombie3, setup)
	return zombie3
end

---------------------------------------------
-- ZUMBI Boss:
---------------------------------------------

loader.newZombieBoss = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/zombieBoss.png", {width = 70, height = 74, numFrames = 1})
	local sequenceData = {		
		{name = "right", sheet = spriteSheet,  frames = {1}, time = 400},
		{name = "down", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "left", sheet = spriteSheet, frames = {1}, time = 400},
		{name = "up", sheet = spriteSheet, frames = {1}, time = 400}
	}
	local zombieBoss = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 2,
		locX = 1,
		locY = mRandom(16,19),
		rotation = 90
	}
	mte.physics.addBody( zombieBoss, "dynamic" )
	mte.addSprite(zombieBoss, setup)
	return zombieBoss
end

loader.newAim = function()
	local spriteSheet = graphics.newImageSheet("images/ui/target.png", {width = 50, height = 50, numFrames = 1})
	local sequenceData = {{name = "default", frames = {1}, time = 400}}
	local aim = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite", 
		layer = 3,
		locX = 17,
		locY = 10,
		offsetX = 13,
		offsetY = -300
	}
	mte.addSprite(aim, setup)
	return aim
end

loader.newBullet = function()
	local spriteSheet = graphics.newImageSheet("images/ui/bullet.png", {width = 5, height = 95, numFrames = 1})
	local sequenceData = {{name = "default", frames = {1}, time = 400}}
	local bullet = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite",
		layer = 2,
		locX = 17,
		locY = 10,
		offsetX = 12,
		offsetY = -120
	}
	mte.physics.addBody( bullet, "dynamic" )
	mte.addSprite(bullet, setup)
	return bullet
end

loader.newExplosion = function()
	local spriteSheet = graphics.newImageSheet("images/ui/bullet.png", {width = 5, height = 95, numFrames = 1})
	local sequenceData = {{name = "default", frames = {1}, time = 400}}
	local bullet = display.newSprite(spriteSheet, sequenceData)
	local setup = {
		kind = "sprite",
		layer = 2,
		locX = 17,
		locY = 10,
		offsetX = 12,
		offsetY = -120
	}
	mte.physics.addBody( bullet, "dynamic" )
	mte.addSprite(bullet, setup)
	return bullet
end

loader.newAssaultClass = function()
	
	local rifleImg = display.newImage("images/sprites/weapons/rifle.png", 310, 52)
	rifleImg.xScale = 0.2
	rifleImg.yScale = 0.2

	local handgunImg = display.newImage("images/sprites/weapons/handgun.png", 450, 52)
	handgunImg.xScale = 0.06
	handgunImg.yScale = 0.06
	return rifleImg, handgunImg
end

loader.newEngineerClass = function()
	
end

return loader
