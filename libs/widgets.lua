-------------------------------------------------------------------

-- widgets.lua

-------------------------------------------------------------------

local function backBtnClick()
	composer.gotoScene( "scenes.start", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function playBtnClick()
	composer.gotoScene( "levels.level1", "fade", 500 )
	
	return true	-- indicates successful touch
end