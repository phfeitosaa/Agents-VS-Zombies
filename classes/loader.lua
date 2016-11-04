-- loader.lua

local loader = {}

----------------------------------------------
-- playerHandgun:
----------------------------------------------

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
		locX = mRandom(1,32),
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
		locX = mRandom(1,32),
		locY = 1
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
		locX = mRandom(1,32),
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
		locX = mRandom(1,32),
		locY = 1
	}
	mte.physics.addBody( zombieBoss, "dynamic" )
	mte.addSprite(zombieBoss, setup)
	return zombieBoss
end

return loader
