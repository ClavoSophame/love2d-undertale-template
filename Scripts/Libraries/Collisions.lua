local collisions = {}

function collisions.FollowShape(sprite)
    local data_tab = {}

    local x, y = sprite.x, sprite.y
    local w, h = sprite.width * sprite.xscale, sprite.height * sprite.yscale
    local angle = sprite.rotation
    local xpivot, ypivot = sprite.xpivot, sprite.ypivot

    local screenX, screenY = love.graphics.transformPoint(x, y)
    data_tab = {
        x = screenX + w * (0.5 - xpivot) * math.cos(math.rad(angle)) - h * (0.5 - ypivot) * math.sin(math.rad(angle)),
        y = screenY + h * (0.5 - ypivot) * math.cos(math.rad(angle)) + w * (0.5 - xpivot) * math.sin(math.rad(angle)),
        w = math.abs(w),
        h = math.abs(h),
        angle = angle
    }

    return data_tab
end

function collisions.RectangleWithPoint(rectangle, point)
    local is_colliding = false
    local rect = rectangle
    local p = point

    local dx, dy = p.x - rect.x, p.y - rect.y
    local w, h = rect.w, rect.h
    local angle = math.rad(rect.angle)
    local cos, sin = math.cos(angle), math.sin(angle)

    if (dx * cos + dy * sin <= w / 2 and dx * cos + dy * sin >= -w / 2 and dy * cos - dx * sin <= h / 2 and dy * cos - dx * sin >= -h / 2) then
        is_colliding = true
    end

    return is_colliding
end

function collisions.CircleWithPoint(circle, point)
    local is_colliding = false
    local circ = circle
    local p = point

    local dx, dy = p.x - circ.x, p.y - circ.y
    local a, b = circ.w, circ.h
    local angle = math.rad(circ.angle)
    local cos, sin = math.cos(angle), math.sin(angle)
    local X, Y = dx * cos + dy * sin, dy * cos - dx * sin

    if (X ^ 2 / a ^ 2 + Y ^ 2 / b ^ 2 <= 1) then
        is_colliding = true
    end

    return is_colliding
end

function collisions.RectangleWithRectangle(rectangle1, rectangle2)
    local rect1 = rectangle1
    local rect2 = rectangle2

    local function getRotatedVertices(rect)
        local angle = math.rad(rect.angle)
        local cosA = math.cos(angle)
        local sinA = math.sin(angle)

        local halfW = rect.w / 2
        local halfH = rect.h / 2

        local vertices = {
            {x = -halfW, y = -halfH},
            {x = halfW,  y = -halfH},
            {x = -halfW, y = halfH},
            {x = halfW,  y = halfH}
        }

        for _, vertex in ipairs(vertices)
        do
            local x = vertex.x * cosA - vertex.y * sinA + rect.x
            local y = vertex.x * sinA + vertex.y * cosA + rect.y
            vertex.x, vertex.y = x, y
        end

        return vertices
    end

    local function projectRectangle(vertices, axis)
        local min = math.huge
        local max = -math.huge

        for _, vertex in ipairs(vertices)
        do
            local dot = vertex.x * axis.x + vertex.y * axis.y
            if (dot < min) then min = dot end
            if (dot > max) then max = dot end
        end

        return min, max
    end

    local function getAxes(rect)
        local angle = math.rad(rect.angle)
        local cosA = math.cos(angle)
        local sinA = math.sin(angle)

        return {
            {x = cosA, y = sinA},
            {x = -sinA, y = cosA}
        }
    end

    local vertices1 = getRotatedVertices(rect1)
    local vertices2 = getRotatedVertices(rect2)

    local axes = {}
    for _, axis in ipairs(getAxes(rect1))
    do
        table.insert(axes, axis)
    end
    for _, axis in ipairs(getAxes(rect2))
    do
        table.insert(axes, axis)
    end

    for _, axis in ipairs(axes)
    do
        local min1, max1 = projectRectangle(vertices1, axis)
        local min2, max2 = projectRectangle(vertices2, axis)
        if (max1 < min2 or max2 < min1) then
            return false
        end
    end

    return true
end

function collisions.RectangleWithCircle(rectangle, circle)
    local function p2r(w, h, cos, sin, dx, dy)
        return math.abs(dx*cos + dy*sin)*2 <= w and math.abs(-dx*sin + dy*cos)*2 <= h
    end

    local function solve(a,b, p,q)
        -- {x^2/a^2 + y^2/b^2 == 1} & {p*x + q*y == 0}
        if q == 0 then
            return 0, b
        elseif p == 0 then
            return a, 0
        else
            local x = a*b*math.abs(q)/math.sqrt(b*b*q*q + a*a*p*p)
            return x, -x*p/q
        end
    end

    local function p2e(a, b, x, y)
        return (x*x)/(a*a) + (y*y)/(b*b) <= 1
    end

    local function ellipseToRectangle(a, b, x, y, w, h, cos, sin)
        -- 中心在(0,0), 半长轴长为a, 半短轴长为b的椭圆
        -- 中心在(x,y), 宽为w, 高为h, 方向为(cos,sin)的矩形
        -- 解四切点, 对应矩形的象限来区分
        --[[
        -- 新情况: 实际上不需要区分象限
        local x1, y1 = solve(a, b, -sin/(a*a), cos/(b*b))
        local x3, y3 if (cos >= 0) == (x1 >= 0) then
            x3 = -x1
            y3 = -y1
        else
            x3 = x1
            y3 = y1
            x1 = -x3
            y1 = -y3
        end
        local x2, y2 = solve(a, b, cos/(a*a), sin/(b*b))
        local x4, y4 if (sin <= 0) == (x2 >= 0) then
            x4 = -x2
            y4 = -y2
        else
            x4 = x2
            y4 = y2
            x2 = -x4
            y2 = -y4
        end
        --]]
        local x1, y1 = solve(a, b, -sin/(a*a), cos/(b*b))
        local x2, y2 = solve(a, b, cos/(a*a), sin/(b*b))
        local wx, wy = w*cos, w*sin
        local hx, hy = -h*sin, h*cos
        --[[
        local lg = require "love.graphics"
        local points = {x1,y1, x2,y2, x3,y3, x4,y4}
        for i = 1, 4 do
            lg.push()
            lg.translate(points[i*2-1], points[i*2])
            lg.rotate(math.atan2(sin, cos))
            lg.setColor(1,0,0,0.5)
            lg.rectangle("line", -w/2,-h/2, w,h)
            lg.pop()
        end
        lg.setColor(1,0,0,0.5)
        lg.ellipse("line", (wx+hx)/2, (wy+hy)/2, a, b)
        lg.ellipse("line", (-wx+hx)/2, (-wy+hy)/2, a, b)
        lg.ellipse("line", (-wx-hx)/2, (-wy-hy)/2, a, b)
        lg.ellipse("line", (wx-hx)/2, (wy-hy)/2, a, b)
        --]]

        return p2r(w,h, cos,sin, x-x1,y-y1)
        or p2r(w,h, cos,sin, x-x2,y-y2)
        --or p2r(w,h, cos,sin, x-x3,y-y3)
        --or p2r(w,h, cos,sin, x-x4,y-y4)
        or p2r(w,h, cos,sin, x+x1,y+y1)
        or p2r(w,h, cos,sin, x+x2,y+y2)
        or p2e(a,b, x-(wx+hx)/2,y-(wy+hy)/2)
        or p2e(a,b, x-(-wx+hx)/2,y-(-wy+hy)/2)
        or p2e(a,b, x-(-wx-hx)/2,y-(-wy-hy)/2)
        or p2e(a,b, x-(wx-hx)/2,y-(wy-hy)/2)
    end

    local rec_x = rectangle.x - circle.x
    local rec_y = rectangle.y - circle.y
    local rad = math.rad(circle.angle)
    local rec_angle = rectangle.angle - circle.angle
    local rec_rad = math.rad(rec_angle)
    rec_x, rec_y = rec_x*math.cos(rad) + rec_y*math.sin(rad), -rec_x*math.sin(rad) + rec_y*math.cos(rad)
    return ellipseToRectangle(circle.w/2, circle.h/2, rec_x, rec_y, rectangle.w, rectangle.h, math.cos(rec_rad), math.sin(rec_rad))
end

function collisions.CircleWithCircle(circle1, circle2)
    local function get_axes(angle)
        local cosA, sinA = math.cos(angle), math.sin(angle)
        return { {cosA, sinA}, {-sinA, cosA} }
    end

    local function get_projection_length(a, b, angle, ax, ay)
        local cosA, sinA = math.cos(angle), math.sin(angle)
        local projX = a * math.abs(ax * cosA + ay * sinA)
        local projY = b * math.abs(-ax * sinA + ay * cosA)
        return math.sqrt(projX^2 + projY^2)
    end

    local x1, y1 = circle1.x, circle1.y
    local a1, b1 = circle1.w / 2, circle1.h / 2
    local angle1 = math.rad(circle1.angle)

    local x2, y2 = circle2.x, circle2.y
    local a2, b2 = circle2.w / 2, circle2.h / 2
    local angle2 = math.rad(circle2.angle)

    if (a1 == b1 and a2 == b2) then
        local r1, r2 = a1, a2
        local dx, dy = x2 - x1, y2 - y1
        local distance = math.sqrt(dx * dx + dy * dy)
        return distance <= (r1 + r2)
    end

    local axes = {}
    for _, axis in ipairs(get_axes(angle1)) do table.insert(axes, axis) end
    for _, axis in ipairs(get_axes(angle2)) do table.insert(axes, axis) end

    local dx, dy = x2 - x1, y2 - y1
    local center_dist = math.sqrt(dx * dx + dy * dy)
    if (center_dist > 0) then
        table.insert(axes, {dx / center_dist, dy / center_dist})
    end

    for _, axis in ipairs(axes)
    do
        local ax, ay = axis[1], axis[2]

        local proj1 = get_projection_length(a1, b1, angle1, ax, ay)
        local proj2 = get_projection_length(a2, b2, angle2, ax, ay)

        local center_proj = math.abs(dx * ax + dy * ay)
        if (center_proj > (proj1 + proj2)) then
            return false
        end
    end

    return true
end

return collisions