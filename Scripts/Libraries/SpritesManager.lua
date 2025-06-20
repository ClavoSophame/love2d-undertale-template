local sprites = {
    images = {}
}

sprites.imageCache = {}

local functions = {
    MoveTo = function(self, x, y)
        self.x = x
        self.y = y
    end,
    Move = function(self, x, y)
        self.x = self.x + x
        self.y = self.y + y
    end,
    SetSpeed = function(self, x, y)
        self.velocity.x = x
        self.velocity.y = y
    end,
    Scale = function(self, x, y)
        self.xscale = x
        self.yscale = y
    end,
    Pivot = function(self, x, y)
        self.xpivot = x
        self.ypivot = y
    end,
    Shear = function(self, x, y)
        self.xshear = x
        self.yshear = y
    end,
    Set = function(self, path)
        self.image = love.graphics.newImage("Resources/Sprites/" .. path)
        self.image:setFilter("nearest", "nearest")
    end,
    GetPosition = function(self)
        return self.x, self.y
    end,
    SetAnimation = function(self, frames, interval, mode)
        self.animation.mode = (mode or "loop")
        self.animation.index = 0
        self.animation.frames = frames
        self.animation.interval = interval
    end,
    SetStencils = function(self, stencils)
        self.stencils.use = true
        self.stencils.sources = (stencils or {})
        if (#self.stencils.sources == 0) then
            self.stencils.use = false
        end
    end,
    SetShaders = function(self, shaders)
        self.shaders.use = true
        self.shaders.sources = (shaders or {})
        if (#self.shaders.sources == 0) then
            self.shaders.use = false
        end
    end,
    SetParent = function(self, parent)
        if (parent) then
            self.parent = parent
            self.x = 0
            self.y = 0
        else
            self.parent = nil
        end
    end,
    Dust = function(self, sound)
        self.dust.use = true
        self.dust.shader = love.graphics.newShader("Scripts/Shaders/dust")
        self.dust.shader:send("screen_size_inv", {1 / self.width, 1 / self.height})
        if (sound) then
            audio.PlaySound("snd_dust.wav")
        end
    end,
    Destroy = function(self)
        for k, sprite in ipairs(sprites.images) do
            if (sprite == self) then
                sprite.isactive = false
                if (sprite.dust.shader) then
                    sprite.dust.shader:release()
                    sprite.dust.shader = nil
                end
                for i = #sprite.shaders, 1, -1
                do
                    local shader = sprite.shaders[i]
                    if (shader) then
                        shader:release()
                        shader = nil
                    end
                end
                table.remove(sprites.images, k)
                break
            end
        end
        for k, layer in ipairs(layers.objects) do
            if (layer == self) then
                table.remove(layers.objects, k)
                break
            end
        end
    end,
    Remove = function(self)
        self:Destroy()
    end
}
functions.__index = functions

function sprites.CreateSprite(path, layer)
    local sprite = {}

    sprite.shaders = {
        use = false,
        sources = {}
    }
    sprite.stencils = {
        use = false,
        sources = {}
    }

    sprite.path = path
    sprite.parent = nil
    sprite.realName = sprite.path:sub(1, #sprite.path - 4)
    sprite.isBullet = false
    if (sprites.imageCache[sprite.path]) then
        sprite.image = sprites.imageCache[sprite.path]
    else
        sprites.imageCache[sprite.path] = love.graphics.newImage("Resources/Sprites/" .. sprite.path)
        sprites.imageCache[sprite.path]:setFilter("nearest", "nearest")
        sprite.image = sprites.imageCache[sprite.path]
    end
    sprite.layer = layer
    sprite.dust = {
        use = false,
        time = 0,
        shader = nil
    }

    sprite.visible = true
    sprite.isactive = true

    sprite.alpha = 1
    sprite.color = {1, 1, 1}
    sprite.width = sprite.image:getWidth()
    sprite.height = sprite.image:getHeight()
    sprite.xpivot = 0.5
    sprite.ypivot = 0.5
    sprite.rotation = 0
    sprite.x = 320
    sprite.y = 240
    sprite.absx = 0
    sprite.absy = 0
    sprite.velocity = {x = 0, y = 0}
    sprite.xshear = 0
    sprite.yshear = 0
    sprite.xscale = 1
    sprite.yscale = 1

    -- Animation.
    sprite.animation = {
        mode = "loop",
        index = 0,
        frames = {},
        interval = 0,
        time = 0
    }

    function sprite:Draw()
        if (sprite.isactive) then
            love.graphics.push()

            if (sprite.shaders.use) then
                if (#sprite.shaders.sources > 0) then
                    for i = 1, #sprite.shaders.sources do
                        love.graphics.setShader(sprite.shaders.sources[i])
                    end
                end
            end

            if (sprite.dust.use) then
                love.graphics.setShader(sprite.dust.shader)
            end

            if (sprite.stencils.use) then
                love.graphics.clear(false, false, true, 0)
                masks.Draw(sprite.stencils.sources)
                love.graphics.setStencilTest("greater", 0)
            end

            if (sprite.alpha > 1) then sprite.alpha = 1 end
            if (sprite.alpha < 0) then sprite.alpha = 0 end
            sprite.color[4] = sprite.alpha
            love.graphics.setColor(sprite.color)

            sprite.width = sprite.image:getWidth()
            sprite.height = sprite.image:getHeight()
            love.graphics.draw(sprite.image, sprite.x, sprite.y, math.rad(sprite.rotation), sprite.xscale, sprite.yscale, sprite.xpivot * sprite.width, sprite.ypivot * sprite.height, sprite.xshear, sprite.yshear)

            if (sprite.dust.use) then
                love.graphics.setShader()
            end

            masks.reset()
            love.graphics.setShader()
            love.graphics.pop()
        end
    end

    setmetatable(sprite, functions)
    table.insert(sprites.images, sprite)
    table.insert(layers.objects, sprite)
    return sprite
end

function sprites.Update(dt)
    for _, sprite in ipairs(sprites.images) do
        sprite.x = sprite.x + sprite.velocity.x
        sprite.y = sprite.y + sprite.velocity.y

        if (#sprite.animation.frames > 0) then
            sprite.animation.time = sprite.animation.time + 1
            if (sprite.animation.time >= sprite.animation.interval) then
                sprite.animation.time = 0

                sprite.animation.index = sprite.animation.index + 1
                if (sprite.animation.index > #sprite.animation.frames) then
                    if (sprite.animation.mode == "loop") then
                        sprite.animation.index = 1
                    elseif (sprite.animation.mode == "oneshot") then
                        sprite.animation.index = #sprite.animation.frames
                    elseif (sprite.animation.mode == "oneshot-empty") then
                        sprite.animation.index = 1
                        sprite:Destroy()
                    end
                end
                sprite:Set(sprite.animation.frames[sprite.animation.index])
            end
        end

        if (sprite.parent) then
            local parentX, parentY = sprite.parent.x, sprite.parent.y
            sprite.x = parentX + sprite.absx
            sprite.y = parentY + sprite.absy
        end

        if (sprite.dust.use) then
            sprite.dust.time = sprite.dust.time + dt

            local shader = sprite.dust.shader
            shader:send("dt", dt)
            shader:send("scan_y", sprite.dust.time * 1)
            
            if (sprite.dust.time >= 1) then
                sprite:Destroy()
            end
        end
    end
end

function sprites.Draw()
    for _, sprite in ipairs(sprites.images) do
        sprite:Draw()
    end
end

function sprites.RemoveImage(path)
    for i = #sprites.images, 1, -1
    do
        local sprite = sprites.images[i]
        if (sprite.path == path) then
            sprite:Destroy()
            table.remove(sprites.images, i)
        end
    end
    sprites.imageCache[path] = nil
end

function sprites.clear()
    for i = #sprites.images, 1, -1
    do
        local sprite = sprites.images[i]
        sprites.RemoveImage(sprite.path)
    end
end

return sprites