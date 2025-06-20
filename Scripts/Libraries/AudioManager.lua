local audio = {
    sources = {}
}

local functions = {
    VolumeTransition = function(instance, begin, target, duration)
        if (instance.source) then
            local source = instance.source
            source:setVolume(begin)
            instance.effects.volume = {
                duration = 0,
                target = target,
                begin = begin,
                total = duration
            }
        end
    end,
    PitchTransition = function(instance, begin, target, duration)
        if (instance.source) then
            local source = instance.source
            source:setPitch(begin)
            instance.effects.pitch = {
                duration = 0,
                target = target,
                begin = begin,
                total = duration
            }
        end
    end
}
functions.__index = functions

function audio.PlaySound(sound, volume, looping)
    local instance = {}
    instance.source = love.audio.newSource("Resources/Sounds/" .. sound, "static")
    instance.source:setVolume(volume or 1)
    instance.source:setLooping(looping or false)
    instance.source:play()

    instance.time = 0
    instance.path = sound
    instance.duration = instance.source:getDuration("seconds")
    instance.effects = {
        volume = {
            duration = 1,
            target = 1,
            begin = 1,
            total = 0
        },
        pitch = {
            duration = 1,
            target = 1,
            begin = 1,
            total = 0
        }
    }

    setmetatable(instance, functions)
    table.insert(audio.sources, instance)
    return instance.source, instance
end

function audio.PlayMusic(music, volume, looping)
    local instance = {}
    instance.source = love.audio.newSource("Resources/Music/" .. music, "stream")
    instance.source:setVolume(volume or 1)
    instance.source:setLooping(looping == nil and true or looping)
    instance.source:play()

    instance.time = 0
    instance.duration = instance.source:getDuration("seconds")
    instance.pausePosition = 0
    instance.path = music
    instance.effects = {
        volume = {
            duration = 1,
            target = 1,
            begin = 1,
            total = 0
        },
        pitch = {
            duration = 1,
            target = 1,
            begin = 1,
            total = 0
        }
    }

    setmetatable(instance, functions)
    table.insert(audio.sources, instance)
    return instance.source, instance
end

function audio.MusicPause(inst)
    if (inst.source and inst.source:isPlaying()) then
        inst.pausePosition = inst.source:tell("seconds")
        inst.source:stop()
        inst.source:release()
        inst.source = nil
        return true
    end
    return false
end

function audio.MusicUnpause(inst)
    if (not inst.source and inst.pausePosition) then
        local musicPath = inst.path
        inst.source = love.audio.newSource(musicPath, "stream")
        inst.source:setLooping(inst.source:isLooping() == nil and true or false)
        inst.source:setVolume(inst.volume or 1)

        inst.source:seek(inst.pausePosition)
        inst.source:play()
        return true
    end
    return false
end

function audio.Update()
    for i = #audio.sources, 1, -1 do
        local inst = audio.sources[i]
        local volume_table = inst.effects.volume
        if (volume_table.duration <= volume_table.total) then
            volume_table.duration = volume_table.duration + love.timer.getDelta()
            inst.source:setVolume(volume_table.begin + (volume_table.target - volume_table.begin) * volume_table.duration / volume_table.total)
        end

        local pitch_table = inst.effects.pitch
        if (pitch_table.duration <= pitch_table.total) then
            pitch_table.duration = pitch_table.duration + love.timer.getDelta()
            inst.source:setPitch(pitch_table.begin + (pitch_table.target - pitch_table.begin) * pitch_table.duration / pitch_table.total)
        end

        if (not inst.source:isLooping()) then
            inst.time = inst.time + love.timer.getDelta()
            if (inst.time >= inst.duration) then
                inst.source:stop()
                inst.source:release()
                table.remove(audio.sources, i)
                break
            end
        end
    end
end

function audio.ClearAll()
    for i = #audio.sources, 1, -1 do
        local instance = audio.sources[i]
        if (instance.source) then
            instance.source:stop()
            instance.source:release()
        end
    end
    audio.sources = {}
end

return audio