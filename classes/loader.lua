-- loader.lua

local loader = {}

--==============================================================
-- Carregar o player e o zumbi:
--==============================================================

-- PLAYER:
loader.newPlayer = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/Glock.png", {width = 50, height = 74, numFrames = 1})
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
		locX = 17,
		locY = 10,
		levelWidth = 40,
		levelHeight = 59
	}
	mte.physics.addBody( player, "dynamic" )
	mte.addSprite(player, setup)
	mte.setCameraFocus(player)
	return player
end

-- ZUMBI:
loader.newZombie = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/zombie1.png", {width = 50, height = 57, numFrames = 1})
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
		locX = mRandom(1,32),
		locY = 1,
		levelWidth = 40,
		levelHeight = 46
	}
	mte.physics.addBody( zombie, "dynamic" )
	mte.addSprite(zombie, setup)
	return zombie
end

return loader
