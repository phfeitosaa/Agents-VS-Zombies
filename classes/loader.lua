-- loader.lua

local loader = {}

--==============================================================
-- Carregar o player e o zumbi:
--==============================================================

-- PLAYER:
loader.newPlayer = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/player1_gun.png", {width = 48, height = 48, numFrames = 1})
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
		levelWidth = 48,
		levelHeight = 48
	}
	mte.physics.addBody( player, "dynamic" )
	mte.addSprite(player, setup)
	mte.setCameraFocus(player)
	return player
end

-- ZUMBI:
loader.newZombie = function()
	local spriteSheet = graphics.newImageSheet("images/sprites/zombie.png", {width = 35, height = 43, numFrames = 1})
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
		levelWidth = 38,
		levelHeight = 46
	}
	mte.physics.addBody( zombie, "dynamic" )
	mte.addSprite(zombie, setup)
	return zombie
end

return loader
