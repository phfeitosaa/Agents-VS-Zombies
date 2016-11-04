-----------------------------------------------------------------------------------------
--
-- start.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
composer.recycleOnSceneChange = true -- Automatically remove scenes from memory

local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- Importando arquivos necessários pro jogo:
local sounds = require('libs.sounds')

--------------------------------------------

-- forward declarations and other locals
local startBtn


function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "images/backStart.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	-- create a widget button (which will loads level1.lua on release)
	startBtn = widget.newButton(
		{
			defaultFile  = "images/ui/btnStart.png",
			overFile = "images/ui/btnStartHover.png",
			width=222, height=60,
			onRelease = function()
				sounds.play('tap')
				composer.gotoScene('scenes.menu', {time = 500, effect = 'slideLeft'})
			end
		}
	)
	startBtn.x = display.contentCenterX
	startBtn.y = display.contentHeight - 90
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( startBtn )

	sounds.playStream('menu_music')
end

-- Android's back button action
function scene:gotoPreviousScene()
	native.showAlert('Agents VS Zombies', 'Você tem certeza que quer sair do jogo?', {'Sim', 'Cancelar'}, function(event)
		if event.action == 'clicked' and event.index == 1 then
			native.requestExit()
		end
	end
	)
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
		--audio.play( soundTable["backgroundsnd"], {loops=-1})
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then

		-- Called when the scene is on screen and is about to move off screen
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		--audio.fadeOut( { time=500 } )
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	if startBtn then
		startBtn:removeSelf()	-- widgets must be manually removed
		startBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene