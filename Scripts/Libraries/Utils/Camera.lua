local Camera = {}
Camera.__index = Camera

-- Constructor for the Camera class
function Camera:new(x, y, xscale, yscale, rotation)
    local instance = setmetatable({}, Camera)
    instance.x = x or 0
    instance.y = y or 0
    instance.xscale = xscale or 1
    instance.yscale = yscale or 1
    instance.rotation = rotation or 0
    instance.centerX = love.graphics.getWidth() / 2
    instance.centerY = love.graphics.getHeight() / 2
    instance.boundActive = false
    instance.minX = 0
    instance.minY = 0
    instance.maxX = love.graphics.getWidth()
    instance.maxY = love.graphics.getHeight()

    -- Shake variables
    instance.shakeMagnitude = 0
    instance.shakeDuration = 0
    instance.shakeTime = 0
    instance.shakeDecay = true  -- Default decay behavior

    return instance
end

-- Setters and Getters for Camera properties
function Camera:setPosition(x, y)
    self.x = x
    self.y = y
end
function Camera:getPosition()
    return self.x, self.y
end

-- Getters for Camera properties
function Camera:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

-- Set the scale and rotation of the camera
function Camera:setScale(xscale, yscale)
    self.xscale = xscale
    self.yscale = yscale
end

function Camera:setAngle(rotation)
    self.rotation = rotation
end

-- Let the camera shake.
-- magnitude: how strong the shake is
-- duration: how long the shake lasts
-- decay: if true, the shake will decay over time. If false, the shake will be constant.
function Camera:shake(magnitude, duration, decay)
    self.shakeMagnitude = magnitude or 0
    self.shakeDuration = duration or 0
    self.shakeTime = self.shakeDuration
    self.shakeDecay = decay == nil and true or decay  -- Default to true if decay is nil
end

function Camera:setBounds(minX, minY, maxX, maxY)
    self.minX = minX
    self.minY = minY
    self.maxX = maxX
    self.maxY = maxY
    self.boundActive = true
end

function Camera:setBoundsBlock(x, y, w, h)
    self.minX = x
    self.minY = y
    self.maxX = x + w
    self.maxY = y + h
    self.boundActive = true
end

function Camera:update(dt)
    if (self.shakeTime > 0) then
        self.shakeTime = self.shakeTime - 1
        if (self.shakeTime <= 0) then
            self.shakeMagnitude = 0
        end
    end
    if (self.boundActive) then
        self.x = maths.Clamp(self.x, self.minX, self.maxX)
        self.y = maths.Clamp(self.y, self.minY, self.maxY)
    end
end

function Camera:apply()
    local shakeOffsetX = 0
    local shakeOffsetY = 0

    if (self.shakeTime > 0) then
        local currentMagnitude = self.shakeMagnitude
        if (self.shakeDecay) then
            currentMagnitude = self.shakeMagnitude * (self.shakeTime / self.shakeDuration)
        end
        
        shakeOffsetX = (math.random() - 0.5) * 2 * currentMagnitude
        shakeOffsetY = (math.random() - 0.5) * 2 * currentMagnitude
    end

    love.graphics.push()
    love.graphics.translate(self.centerX, self.centerY)
    love.graphics.rotate(math.rad(self.rotation))
    love.graphics.scale(self.xscale, self.yscale)
    love.graphics.translate(-self.x + shakeOffsetX - self.centerX, -self.y + shakeOffsetY - self.centerY)
end

function Camera:reset()
    love.graphics.pop()
end

return Camera