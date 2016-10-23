-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- Importando arquivos necessários pro jogo:
local sounds = require('libs.sounds')
local widgets = require('libs.widgets')

--------------------------------------------


function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "images/backMenu.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	

	BackBtn = widget.newButton(
		{
			label="BACK",
			labelColor = { default={255}, over={128} },
			width=154, height=40,
			onRelease = function()
				sounds.play('tap')
				composer.gotoScene('scenes.start', {time = 500, effect = 'slideRight'})
			end
		}
	)

	BackBtn.x = 30
	BackBtn.y = 300

	PlayBtn = widget.newButton(
		{
			label="START",
			labelColor = { default={255}, over={128} },
			width=154, height=40,
			fontSize = 24,
			onRelease = function()
				sounds.play('tap')
				composer.gotoScene('levels.level1', {time = 500, effect = 'fade'})
			end
		}
	)
	PlayBtn.x = 430
	PlayBtn.y = 70
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( PlayBtn )
	sceneGroup:insert( BackBtn )

	self.gotoPreviousScene = 'scenes.menu' -- Allow going back on back button press
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)

	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end

	if BackBtn then
		BackBtn:removeSelf()
		BackBtn = nil
	end

	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene