local GB = {
    instances = {}
}
local functions = {
    Beam = function(gb, angle)
        local beam = sprites.CreateSprite("Blaster/" .. gb.sprite_path .. "beam.png", 899 + global:GetVariable("LAYER"))
        beam['relative_angle'] = angle
        beam.rotation = gb.blaster.rotation + angle - 90
        beam:MoveTo(gb.blaster.x, gb.blaster.y)
        beam.xpivot = 1
        beam:Scale(2, 2)
        beam.collisions = {harms = {{"self"}}}
        beam.isBullet = true
        table.insert(gb.beams, beam)
    end,
    Destroy = function(blaster)
        for k, v in pairs(GB.instances)
        do
            if (v == blaster) then
                for i = #blaster.beams, 1, -1
                do
                    local b = blaster.beams[i]
                    if (b.isactive) then
                        b:Destroy()
                        table.remove(blaster.beams, i)
                    end
                end
                v.blaster:Destroy()
                blaster = nil
                table.remove(GB, k)
            end
        end
    end
}
functions.__index = functions

---Create a new GB.
function GB:New(begin, final, angles, waittime, firingtime, sprite_prefix, sounds_prefix)
    local gb = {
        beams = {}
    }

    gb.isactive = true
    gb.canmove = true
    gb.time = 0
    gb.begin = begin
    gb.final = final
    gb.angles = angles
    gb.anglespeed = 0
    gb.default_fire = true

    gb.waittime = (waittime or 40)
    gb.firingtime = (firingtime or 40)

    gb.sprite_path = (sprite_prefix or "Default/")
    gb.sounds_path = (sounds_prefix or "")

    audio.PlaySound("Blaster/" .. gb.sounds_path .. "snd_intro.wav", false)
    gb.blaster = sprites.CreateSprite("Blaster/" .. gb.sprite_path .. "spr_gasterblaster_0.png", 900 + global:GetVariable("LAYER"))
    gb.blaster:Scale(2, 2)
    gb.blaster.rotation = gb.angles[1]
    gb.blaster:MoveTo(gb.begin[1], gb.begin[2])

    gb.TimeCall = function()
    end

    setmetatable(gb, functions)
    table.insert(GB.instances, gb)
    return gb
end

function GB:Update()
    for i = #GB.instances, 1, -1
    do
        local gb = GB.instances[i]
        if (gb.isactive) then
            gb.time = gb.time + 1
            if (gb.time <= gb.waittime) then
                gb.blaster:Move(
                    (gb.final[1] - gb.blaster.x) / 8, 
                    (gb.final[2] - gb.blaster.y) / 8
                )
                gb.blaster.rotation = gb.blaster.rotation + (gb.angles[2] - gb.blaster.rotation) / 8
            end
            if (gb.time == gb.waittime - 12) then
                gb.blaster:SetAnimation({
                    "Blaster/" .. gb.sprite_path .. "spr_gasterblaster_1.png", 
                    "Blaster/" .. gb.sprite_path .. "spr_gasterblaster_2.png", 
                    "Blaster/" .. gb.sprite_path .. "spr_gasterblaster_3.png", 
                    "Blaster/" .. gb.sprite_path .. "spr_gasterblaster_4.png"
                }, 3)
            elseif (gb.time == gb.waittime) then
                gb.blaster:SetAnimation({
                    "Blaster/" .. gb.sprite_path .. "spr_gasterblaster_5.png", 
                    "Blaster/" .. gb.sprite_path .. "spr_gasterblaster_4.png"
                }, 2)

                if (gb.default_fire) then
                    gb:Beam(0)
                    gb.TimeCall()
                    audio.PlaySound("Blaster/" .. gb.sounds_path .. "snd_fire.wav", false)
                end
            end
            if (gb.time >= gb.waittime) then
                gb.firingtime = gb.firingtime - 1
                if (gb.blaster.isactive) then
                    gb.blaster.rotation = gb.blaster.rotation + gb.anglespeed
                    if (gb.canmove) then
                        gb.blaster:Move(
                            (gb.time - gb.waittime) * math.sin(math.rad(gb.blaster.rotation)), 
                            (gb.time - gb.waittime) * -math.cos(math.rad(gb.blaster.rotation))
                        )
                    end
                    if (#gb.beams == 1) then
                        if (gb.blaster.x < -160 or gb.blaster.x > 800 or gb.blaster.y < -160 or gb.blaster.y > 640) then
                            gb.canmove = false
                        end
                    end
                    if (gb.firingtime < 0 and #gb.beams == 0) then
                        gb:Destroy()
                        table.remove(GB.instances, i)
                    end
                end
            end

            for j = #gb.beams, 1, -1
            do
                local b = gb.beams[j]
                if (b.isactive) then
                    b.rotation = gb.blaster.rotation - 90 + b['relative_angle']
                    b.color = gb.blaster.color
                    b['HurtMode'] = gb.blaster['HurtMode']
                    b:MoveTo(gb.blaster.x, gb.blaster.y)

                    if (gb.firingtime >= 0) then
                        b.yscale = gb.blaster.xscale + 0.25 + 1 * math.sin(gb.firingtime / 4) / 5
                    else
                        b['HurtMode'] = "safe"
                        b.isBullet = false
                        b.alpha = b.alpha - 0.05
                        b.yscale = b.yscale + (0 - b.yscale) / 8
                        if (b.alpha <= 0) then
                            b:Destroy()
                            table.remove(gb.beams, j)
                        end
                    end
                end
            end
        end
    end
end

function GB:clear()
    for i = #GB.instances, 1, -1
    do
        GB.instances[i]:Destroy()
    end
end

return GB