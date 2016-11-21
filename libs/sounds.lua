-- Sounds library
-- Manager for the sound and music files.
-- Automatically loads files and keeps a track of them.
-- Use playSteam() for music files and play() for short SFX files.

local _M = {}

_M.isSoundOn = true
_M.isMusicOn = true

local sounds = {
	menu_music = 'sounds/menu_music.mp3',
	game_music = 'sounds/game_music.ogg',
	heartbeat = 'sounds/heartbeat.wav',
	tap = 'sounds/tap.wav',
	pistol = 'sounds/pistol.wav',
    rifle = 'sounds/rifle.wav',
    shotgun = 'sounds/shotgun.wav',
	noAmmo = 'sounds/outofammo.wav',
	pain1 = 'sounds/pain1.wav',
	pain2 = 'sounds/pain2.wav',
	pain3 = 'sounds/pain3.wav',
	pain4 = 'sounds/pain4.wav',
	pain5 = 'sounds/pain5.wav',
	zombie = 'sounds/zombie.wav',
	exp = 'sounds/exp.flac',
	die = 'sounds/die.mp3'
}

-- Reserve two channels for streams and switch between them with a nice fade out / fade in transition
local audioChannel, otherAudioChannel, currentStreamSound = 1, 2
function _M.playStream(sound, force)
    if not _M.isMusicOn then return end
    if not sounds[sound] then
        print('sounds: no such sound: ' .. tostring(sound))
        return
    end
    sound = sounds[sound]
    if currentStreamSound == sound and not force then return end
    audio.fadeOut({channel = audioChannel, time = 1000})
    audioChannel, otherAudioChannel = otherAudioChannel, audioChannel
    audio.setVolume(0.7, {channel = audioChannel})
    audio.play(audio.loadStream(sound), {channel = audioChannel, loops = -1, fadein = 1000})
    currentStreamSound = sound
end
audio.reserveChannels(2)

-- Keep all loaded sounds here
local loadedSounds = {}
local function loadSound(sound)
    if not loadedSounds[sound] then
        loadedSounds[sound] = audio.loadSound(sounds[sound])
    end
    return loadedSounds[sound]
end

function _M.play(sound, params)
    if not _M.isSoundOn then return end
    if not sounds[sound] then
        print('sounds: no such sound: ' .. tostring(sound))
        return
    end
    return audio.play(loadSound(sound), params)
end

function _M.stop()
    currentStreamSound = nil
    audio.stop()
end

function _M.playPainSnd()

	local x = math.random(1,5)

	if(x == 1) then
		_M.play('pain1')
	elseif(x == 2) then
		_M.play('pain2')
	elseif(x == 3) then
		_M.play('pain3')
	elseif(x == 4) then
		_M.play('pain4')
	else
		_M.play('pain5')
	end 	
 end

 function _M.playZombieSnd()

	local x = math.random(1,5)

	if(x == 1) then
		_M.play('zombie1')
	elseif(x == 2) then
		_M.play('zombie2')
	elseif(x == 3) then
		_M.play('zombie3')
	elseif(x == 4) then
		_M.play('zombie4')
	else
		_M.play('zombie5')
	end 	
 end

return _M
