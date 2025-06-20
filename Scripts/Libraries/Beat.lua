-- The beats library manages beat tracking and updates based on BPM and delta time.
local beats = {}
beats.bpm = 120
beats.beat = 0
beats.last_triggered_beat = -1

-- Checks if the current beat matches the target beat and ensures the beat has not been triggered yet.
function beats.OnBeat(target_beat)
    if (beats.beat >= target_beat and beats.last_triggered_beat < target_beat) then
        beats.last_triggered_beat = target_beat
        return true
    end
    return false
end

-- Sets the current beat value. Validates that the input is a non-negative number.
function beats.SetBeat(beat)
    -- Validate input to ensure it's a number
    if type(beat) ~= "number" or beat < 0 then
        error("Invalid input: beat must be a non-negative number")
    end
    beats.beat = beat
    beats.last_triggered_beat = -1
end

-- Updates the beat based on the BPM and delta time. Ensures the beat does not go negative.
function beats.Update(dt)
    -- Validate input to ensure it's a number
    if type(dt) ~= "number" or dt < 0 then
        error("Invalid input: dt must be a non-negative number")
    end

    -- Ensure beat does not go negative
    beats.beat = beats.beat + (beats.bpm / 60) * dt
end

return beats