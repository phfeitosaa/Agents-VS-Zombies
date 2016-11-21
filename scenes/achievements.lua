-----------------------------------------------------------------------------------------
--
-- achievements.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
composer.recycleOnSceneChange = true -- Automatically remove scenes from memory

local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- Importando arquivos necessários pro jogo:
local sounds = require('libs.sounds')
--local level1 = require('levels.level1')

--------------------------------------------

-- forward declarations and other locals
local background
local BackBtn

function scene:create( event )
	local sceneGroup = self.view

	-- display a background image
	background = display.newImageRect( "images/achievements.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY

	BackBtn = widget.newButton(
		{
			label="back",
			font="Deanna.ttf",
			fontSize = 36,
			labelColor = { default={255}, over={128} },
			width=154, height=40,
			onRelease = function()
				sounds.play('tap')
				composer.gotoScene('scenes.menu', {time = 500, effect = 'slideRight'})
			end
		}
	)

	BackBtn.x = 1
	BackBtn.y = 300
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( BackBtn )

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

	if (background) then
		background:removeSelf()
		background = nil
	end


	if (BackBtn) then
		BackBtn:removeSelf()
		BackBtn = nil
	end

	scene:removeEventListener("create", scene)
	scene:removeEventListener("show", scene)
	scene:removeEventListener("hide", scene)
	scene:removeEventListener("destroy", scene)

	composer.removeScene("scenes.achievements")

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene