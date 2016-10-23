-- Agents VS Zombies
-- Parte do código foi retirado do jogo:
-- Corona Cannon created by Sergey Lerg for Corona Labs.
-- License - MIT.

display.setStatusBar(display.HiddenStatusBar)
system.activate('multitouch')
if system.getInfo('build') >= '2015.2741' then -- Allow the game to be opened using an old Corona version
	display.setDefault('isAnchorClamped', false) -- Needed for scenes/reload_game.lua animation
end

local platform = system.getInfo('platformName')
if platform == 'tvOS' then
	system.setIdleTimer(false)
end

-- Hide navigation bar on Android
if platform == 'Android' then
	native.setProperty('androidSystemUiVisibility', 'immersiveSticky')
end

-- Exit and enter fullscreen mode
-- CMD+CTRL+F on OS X
-- F11 or ALT+ENTER on Windows
if platform == 'Mac OS X' or platform == 'Win' then
	Runtime:addEventListener('key', function(event)
		if event.phase == 'down' and (
				(platform == 'Mac OS X' and event.keyName == 'f' and event.isCommandDown and event.isCtrlDown) or
					(platform == 'Win' and (event.keyName == 'f11' or (event.keyName == 'enter' and event.isAltDown)))
			) then
			if native.getProperty('windowMode') == 'fullscreen' then
				native.setProperty('windowMode', 'normal')
			else
				native.setProperty('windowMode', 'fullscreen')
			end
		end
	end)
end

local composer = require('composer')
composer.recycleOnSceneChange = true -- Automatically remove scenes from memory

-- Add support for back button on Android and Window Phone
-- When it's pressed, check if current scene has a special field gotoPreviousScene
-- If it's a function - call it, if it's a string - go back to the specified scene
if platform == 'Android' or platform == 'WinPhone' then
	Runtime:addEventListener('key', function(event)
		if event.phase == 'down' and event.keyName == 'back' then
			local scene = composer.getScene(composer.getSceneName('current'))
            if scene then
				if type(scene.gotoPreviousScene) == 'function' then
                	scene:gotoPreviousScene()
                	return true
				elseif type(scene.gotoPreviousScene) == 'string' then
					composer.gotoScene(scene.gotoPreviousScene, {time = 500, effect = 'slideRight'})
					return true
				end
            end
		end
	end)
end

-- Show start scene
composer.gotoScene('scenes.start')
