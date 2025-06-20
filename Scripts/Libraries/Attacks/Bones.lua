local Bones = {
    _2D = {}, 
    _3D = {}
}

local functions = {
    _2D = {
        SetStencil = function(bone, masks, mode, value)
            bone.body:SetStencil(masks, mode, value)
            bone.head:SetStencil(masks, mode, value)
            bone.tail:SetStencil(masks, mode, value)
        end, 
        Length = function(bone, length)
            if (length > 0) then
                bone.length = length
            end
        end, 
        Destroy = function(bone)
            bone.body:Destroy()
            bone.head:Destroy()
            bone.tail:Destroy()
        end, 
        SetColor = function(bone, color)
            bone.body.color = color
            bone.head.color = color
            bone.tail.color = color
        end, 
        SetMode = function(bone, mode)
            bone.body.mode = mode
            bone.head.mode = mode
            bone.tail.mode = mode
        end,
        ToUp = function(bone, arena)
            local len = bone.length + 6
            local cos, sin = math.cos(math.rad(bone.rotation)), math.sin(math.rad(bone.rotation))
            bone.body.y = arena.y - arena.height + len / 2
        end,
        ToDown = function(bone, arena)
            local len = bone.length + 6
            local cos, sin = math.cos(math.rad(bone.rotation)), math.sin(math.rad(bone.rotation))
            bone.body.y = arena.y + arena.height - len / 2
        end,
        ToLeft = function(bone, arena)
            local len = bone.length + 6
            local cos, sin = math.cos(math.rad(bone.rotation)), math.sin(math.rad(bone.rotation))
            bone.body.x = arena.x - arena.width + len / 2
        end,
        ToRight = function(bone, arena)
            local len = bone.length + 6
            local cos, sin = math.cos(math.rad(bone.rotation)), math.sin(math.rad(bone.rotation))
            bone.body.x = arena.x + arena.width - len / 2
        end,
    }, 
    _3D = {
        Link = function(bone, whose, point_1, point_2)
            local p1, p2 = bone.points[point_1], bone.points[point_2]
            local length = math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2) * bone.percent
            local rotation = 0
            if (p2.x ~= p1.x) then
                rotation = math.deg(math.atan2(p2.y - p1.y, p2.x - p1.x)) + 90
            end
            local b = Bones:New2D(whose, length)
            b.position = {x = (p1.x + p2.x) / 2, y = (p1.y + p2.y) / 2}
            b.rotation = rotation
            b.targetpoints = {p1, p2}
            table.insert(bone.bones, b)
        end, 
        Projection = function(bone, table)
            local div = (bone.camera[3] - table[3]) / bone.camera[3]
            local resX = (table[1] - bone.position[1]) / div
            local resY = (table[2] - bone.position[2]) / div
        
            return bone.position[1] + resX, bone.position[2] + resY
        end, 
        Rotate = function(bone, axis, angle)
            local axis = axis:lower()
            local function Rota(rx, ry, angle, centerpos)
                local dx, dy = rx - centerpos[1], ry - centerpos[2]
                local X = dx * math.cos(math.rad(angle)) - dy * math.sin(math.rad(angle))
                local Y = dy * math.cos(math.rad(angle)) + dx * math.sin(math.rad(angle))
    
                return centerpos[1] + X, centerpos[2] + Y
            end
    
            for i = 1, #bone.points
            do
                local p = bone.points[i]
                if (p.isactive) then
                    local px, py, pz = p['pos'][1], p['pos'][2], p['pos'][3]
                    if (axis == "x") then
                        bone.angles[1] = angle
                        p['pos'][2], p['pos'][3] = Rota(py, pz, bone.angles[1], {bone.position[2], bone.position[3]})
                    elseif (axis == "y") then
                        bone.angles[2] = angle
                        p['pos'][1], p['pos'][3] = Rota(px, pz, bone.angles[2], {bone.position[1], bone.position[3]})
                    elseif (axis == "z") then
                        bone.angles[3] = angle
                        p['pos'][1], p['pos'][2] = Rota(px, py, bone.angles[3], {bone.position[1], bone.position[2]})
                    end
                end
            end
        end, 
        MoveToRelative = function(bone, x, y)
            bone.position_relative = {x, y}
        end, 
        MoveTo = function (bone, x, y)
            bone.position_relative = {
                x - bone.position[1], 
                y - bone.position[2]
            }
        end, 
        SetStencil = function(bone, masks, mode, value)
            for i = #bone.bones, 1, -1
            do
                local b = bone.bones[i]
                b:SetStencil(masks, mode, value)
            end
        end,
        Destroy = function(bone)
            bone.isactive = false
            for i = #bone.bones, 1, -1
            do
                local b = bone.bones[i]
                b:Destroy()
            end
            for i = #bone.points, 1, -1
            do
                local p = bone.points[i]
                p:Destroy()
            end
        end
    }
}
functions._2D.__index = functions._2D
functions._3D.__index = functions._3D

function Bones:New2D(whose, length)
    local bone = {}

    bone.position = {x = 320, y = 240}
    bone.isactive = true
    bone.length = length
    bone.path = (whose or "Sans")
    bone.head = sprites.CreateSprite("Attacks/" .. (bone.path or "Sans") .. "/spr_s_bonebul_bottom_0.png", global:GetVariable("LAYER"))
    bone.head.rotation = 180
    bone.body = sprites.CreateSprite("px.png", global:GetVariable("LAYER"))
    bone.tail = sprites.CreateSprite("Attacks/" .. (bone.path or "Sans") .. "/spr_s_bonebul_bottom_0.png", global:GetVariable("LAYER"))
    bone.body.isBullet = true
    bone.body.collisions = {harms = {{"self"}}}
    bone.tail.isBullet = true
    bone.tail.collisions = {harms = {{"self"}}}
    bone.head.isBullet = true
    bone.head.collisions = {harms = {{"self"}}}
    if (bone.path == "Sans") then
        bone.body.xscale = 6
    else
        bone.body.xscale = 5
    end
    bone.body.yscale = bone.length
    bone.rotation = 0

    setmetatable(bone, functions._2D)
    table.insert(Bones._2D, bone)
    return bone
end

function Bones:New3D(points)
    local bone = {}

    bone.percent = 0.6
    bone.points = points
    bone.position = {0, 0, 0}
    bone.bones = {}
    bone.position_relative = {0, 0}
    bone.angles = {0, 0, 0}
    bone.anglespeed = {0, 0, 0}
    bone.isactive = true
    for i = #bone.points, 1, -1
    do
        local p = bone.points[i]
        bone.position[1] = bone.position[1] + p[1]
        bone.position[2] = bone.position[2] + p[2]
        bone.position[3] = bone.position[3] + p[3]
    end
    bone.position = {bone.position[1] / #bone.points, bone.position[2] / #bone.points, bone.position[3] / #bone.points}
    bone.camera = {0, 0, -1000}
    setmetatable(bone, functions._3D)
    bone.points = {}
    for i = #points, 1, -1
    do
        local p = points[i]
        local point = sprites.CreateSprite("px.png", global:GetVariable("LAYER"))
        point:Scale(5, 5)
        point.pos = points[i]
        point:MoveTo(bone:Projection(points[i]))
        point.alpha = 0
        table.insert(bone.points, point)
    end

    table.insert(Bones._3D, bone)
    return bone
end

function Bones:Update()
    for i = #Bones._2D, 1, -1
    do
        local b = Bones._2D[i]
        if (b.isactive) then
            local len = b.length + 6
            local cos, sin = math.cos(math.rad(b.rotation)), math.sin(math.rad(b.rotation))
            b.body.rotation = b.rotation
            b.head.rotation = b.rotation + 180
            b.tail.rotation = b.rotation
            b.body.yscale = len
            b.body:MoveTo(b.position.x, b.position.y)
            b.head:MoveTo(b.position.x + len / 2 * sin, b.position.y - len / 2 * cos)
            b.tail:MoveTo(b.position.x - len / 2 * sin, b.position.y + len / 2 * cos)
        end
    end

    for i = #Bones._3D, 1, -1
    do
        local b = Bones._3D[i]
        if (b.isactive) then
            for j = #b.points, 1, -1
            do
                local p = b.points[j]
                if (p.isactive) then
                    local pos1, pos2 = b:Projection(p.pos)
                    p:MoveTo(pos1 + b.position_relative[1], pos2 + b.position_relative[2])
                end
            end
            for j = #b.bones, 1, -1
            do
                local bb = b.bones[j]
                if (bb.isactive) then
                    bb.length = math.sqrt(math.pow(bb.targetpoints[1].x - bb.targetpoints[2].x, 2) + math.pow(bb.targetpoints[1].y - bb.targetpoints[2].y, 2)) * b.percent
                    bb.position = {x = (bb.targetpoints[1].x + bb.targetpoints[2].x) / 2, y = (bb.targetpoints[1].y + bb.targetpoints[2].y) / 2}
                    bb.rotation = math.deg(math.atan2(bb.targetpoints[2].y - bb.targetpoints[1].y, bb.targetpoints[2].x - bb.targetpoints[1].x)) + 90
                end
            end
        end
    end
end

function Bones:Clear()
    for i = #Bones._2D, 1, -1
    do
        local b = Bones._2D[i]
        if (b.isactive) then
            b:Destroy()
        end
    end
end

return Bones