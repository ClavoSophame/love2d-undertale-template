local tween = {
    animations = {},
    customAnimations = {}
}

function tween.CreateTween(variableSetter, type, direction, begin, final, duration)
    local animation = {}

    animation.variableSetter = variableSetter
    animation.type = type
    animation.direction = direction
    animation.begin = begin
    animation.final = final
    animation.duration = duration

    animation.time = 0

    table.insert(tween.animations, animation)
    return animation
end

function tween.CreateCustomTween(name, easingFunc)
    if (type(name) ~= "string") then
        print("Custom tween name must be a string")
        return
    end

    if (type(easingFunc) ~= "function") then
        print("Custom tween easing function must be a function")
        return
    end

    tween.customAnimations[name:lower()] = easingFunc
end

function tween.Update(dt)
    for i = #tween.animations, 1, -1 do
        local animation = tween.animations[i]
        if (animation.time <= animation.duration) then
            animation.time = animation.time + 1
            local name = animation.type .. animation.direction
            local progress = animation.time / animation.duration

            if (name and type(name) == "string") then
                local current = animation.begin

                if (name:lower() == "linear") then
                    current = animation.begin + (animation.final - animation.begin) * progress
                elseif (name:lower() == "quadin") then
                    current = animation.begin + (animation.final - animation.begin) * (progress * progress)
                elseif (name:lower() == "quadout") then
                    progress = 1 - progress
                    current = animation.begin + (animation.final - animation.begin) * (1 - progress * progress)
                elseif (name:lower() == "quadinout") then
                    progress = progress * 2
                    if (progress < 1) then
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * progress * progress
                    else
                        progress = progress - 1
                        current = animation.begin + (animation.final - animation.begin) * (-0.5) * (progress * (progress - 2) - 1)
                    end
                elseif (name:lower() == "sinein") then
                    current = animation.begin + (animation.final - animation.begin) * (1 - math.cos(progress * math.pi / 2))
                elseif (name:lower() == "sineout") then
                    current = animation.begin + (animation.final - animation.begin) * math.sin(progress * math.pi / 2)
                elseif (name:lower() == "sineinout") then
                    current = animation.begin + (animation.final - animation.begin) * (-0.5 * (math.cos(math.pi * progress) - 1))
                elseif (name:lower() == "cubicin") then
                    current = animation.begin + (animation.final - animation.begin) * (progress * progress * progress)
                elseif (name:lower() == "cubicout") then
                    progress = progress - 1
                    current = animation.begin + (animation.final - animation.begin) * (progress * progress * progress + 1)
                elseif (name:lower() == "cubicinout") then
                    progress = progress * 2
                    if progress < 1 then
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * progress * progress * progress
                    else
                        progress = progress - 2
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * (progress * progress * progress + 2)
                    end
                elseif (name:lower() == "quartin") then
                    current = animation.begin + (animation.final - animation.begin) * (progress * progress * progress * progress)
                elseif (name:lower() == "quartout") then
                    progress = progress - 1
                    current = animation.begin + (animation.final - animation.begin) * (1 - progress * progress * progress * progress)
                elseif (name:lower() == "quartinout") then
                    progress = progress * 2
                    if progress < 1 then
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * progress * progress * progress * progress
                    else
                        progress = progress - 2
                        current = animation.begin + (animation.final - animation.begin) * (-0.5) * (progress * progress * progress * progress - 2)
                    end
                elseif (name:lower() == "quintin") then
                    current = animation.begin + (animation.final - animation.begin) * (progress * progress * progress * progress * progress)
                elseif (name:lower() == "quintout") then
                    progress = progress - 1
                    current = animation.begin + (animation.final - animation.begin) * (progress * progress * progress * progress * progress + 1)
                elseif (name:lower() == "quintinout") then
                    progress = progress * 2
                    if progress < 1 then
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * progress * progress * progress * progress * progress
                    else
                        progress = progress - 2
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * (progress * progress * progress * progress * progress + 2)
                    end
                elseif (name:lower() == "expoin") then
                    current = animation.begin + (animation.final - animation.begin) * (2 ^ (10 * (progress - 1)))
                elseif (name:lower() == "expoout") then
                    current = animation.begin + (animation.final - animation.begin) * (-(2 ^ (-10 * progress)) + 1)
                elseif (name:lower() == "expoinout") then
                    progress = progress * 2
                    if progress < 1 then
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * (2 ^ (10 * (progress - 1)))
                    else
                        progress = progress - 1
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * (-(2 ^ (-10 * progress)) + 2)
                    end
                elseif (name:lower() == "circin") then
                    current = animation.begin + (animation.final - animation.begin) * (1 - math.sqrt(1 - progress * progress))
                elseif (name:lower() == "circout") then
                    progress = progress - 1
                    current = animation.begin + (animation.final - animation.begin) * math.sqrt(1 - progress * progress)
                elseif (name:lower() == "circinout") then
                    progress = progress * 2
                    if (progress < 1) then
                        current = animation.begin + (animation.final - animation.begin) * (-0.5 * (math.sqrt(1 - progress * progress) - 1))
                    else
                        progress = progress - 2
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * (math.sqrt(1 - progress * progress) + 1)
                    end
                elseif (name:lower() == "backin") then
                    local s = 1.70158
                    current = animation.begin + (animation.final - animation.begin) * (progress * progress * ((s + 1) * progress - s))
                elseif (name:lower() == "backout") then
                    local s = 1.70158
                    progress = progress - 1
                    current = animation.begin + (animation.final - animation.begin) * (progress * progress * ((s + 1) * progress + s) + 1)
                elseif (name:lower() == "backinout") then
                    local s = 1.70158 * 1.525
                    progress = progress * 2
                    if progress < 1 then
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * (progress * progress * ((s + 1) * progress - s))
                    else
                        progress = progress - 2
                        current = animation.begin + (animation.final - animation.begin) * 0.5 * (progress * progress * ((s + 1) * progress + s) + 2)
                    end
                elseif (name:lower() == "elasticin") then
                    local p = 0.3
                    local s = p / 4
                    progress = progress - 1
                    current = animation.begin + (animation.final - animation.begin) * (-(2 ^ (10 * progress)) * math.sin((progress - s) * (2 * math.pi) / p))
                elseif (name:lower() == "elasticout") then
                    local p = 0.3
                    local s = p / 4
                    current = animation.begin + (animation.final - animation.begin) * ((2 ^ (-10 * progress)) * math.sin((progress - s) * (2 * math.pi) / p) + 1)
                elseif (name:lower() == "elasticinout") then
                    local p = 0.3 * 1.5
                    local s = p / 4
                    progress = progress * 2
                    if (progress < 1) then
                        progress = progress - 1
                        current = animation.begin + (animation.final - animation.begin) * (-0.5 * (2 ^ (10 * progress)) * math.sin((progress - s) * (2 * math.pi) / p))
                    else
                        progress = progress - 1
                        current = animation.begin + (animation.final - animation.begin) * (0.5 * (2 ^ (-10 * progress)) * math.sin((progress - s) * (2 * math.pi) / p) + 1)
                    end
                elseif (name:lower() == "bouncein") then
                    current = animation.begin + (animation.final - animation.begin) * (1 - tween.bounceout(1 - progress))
                elseif (name:lower() == "bounceout") then
                    local n1 = 7.5625
                    local d1 = 2.75

                    if progress < 1 / d1 then
                        current = animation.begin + (animation.final - animation.begin) * (n1 * progress * progress)
                    elseif progress < 2 / d1 then
                        progress = progress - (1.5 / d1)
                        current = animation.begin + (animation.final - animation.begin) * (n1 * progress * progress + 0.75)
                    elseif progress < 2.5 / d1 then
                        progress = progress - (2.25 / d1)
                        current = animation.begin + (animation.final - animation.begin) * (n1 * progress * progress + 0.9375)
                    else
                        progress = progress - (2.625 / d1)
                        current = animation.begin + (animation.final - animation.begin) * (n1 * progress * progress + 0.984375)
                    end
                elseif (name:lower() == "bounceinout") then
                    if progress < 0.5 then
                        current = animation.begin + (animation.final - animation.begin) * (1 - tween.bounceout(1 - progress * 2)) * 0.5
                    else
                        current = animation.begin + (animation.final - animation.begin) * (tween.bounceout((progress - 0.5) * 2) * 0.5 + 0.5)
                    end
                elseif (tween.customAnimations[name:lower()]) then
                    local easingFunc = tween.customEasingFunctions[name:lower()]
                    local easedProgress = easingFunc(progress)
                    current = animation.begin + (animation.final - animation.begin) * easedProgress
                else
                    print("Undefined animation type: " .. (name and name or "null"))
                end
                animation.variableSetter(current)
            else
                print("Invalid animation type: " .. name)
            end
        else
            animation.variableSetter(animation.final)
            table.remove(tween.animations, i)
        end
    end
end

function tween.bounceout(progress)
    local n1 = 7.5625
    local d1 = 2.75

    if progress < 1 / d1 then
        return n1 * progress * progress
    elseif progress < 2 / d1 then
        progress = progress - (1.5 / d1)
        return n1 * progress * progress + 0.75
    elseif progress < 2.5 / d1 then
        progress = progress - (2.25 / d1)
        return n1 * progress * progress + 0.9375
    else
        progress = progress - (2.625 / d1)
        return n1 * progress * progress + 0.984375
    end
end

function tween.clear()
    tween.animations = {}
end

return tween