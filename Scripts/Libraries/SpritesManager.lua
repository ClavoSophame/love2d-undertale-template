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

        self.color[4] = self.alpha
        for _, shader in pairs(self.shaders.sources)
        do
            shader:send("sColor", self.color or {1, 1, 1, 1})
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
        self.dust.totaltime = 1.2
        self.dust.use = true
        self.dust.shader = love.graphics.newShader("Scripts/Shaders/dust")
        self.dust.shader:send("screen_size_inv", {1 / self.width, 1 / self.height})

        self.color[4] = self.alpha
        self.dust.shader:send("sColor", self.color or {1, 1, 1, 1})
        self.dust.image = love.graphics.newCanvas(self.width, self.height)
        self.dust.iter_image = love.graphics.newCanvas(self.width, self.height)
        love.graphics.setCanvas(self.dust.image)
        love.graphics.draw(self.image)
        love.graphics.setCanvas()
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
                    sprite.dust.image:release()
                    sprite.dust.iter_image:release()
                    sprite.dust.image = nil
                    sprite.dust.iter_image = nil
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
    sprite.speed = {x = 0, y = 0}
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

                if (not sprite.shaders.use or #sprite.shaders.sources <= 1) then
                    if (sprite.shaders.use and #sprite.shaders.sources == 1) then
                        love.graphics.setShader(sprite.shaders.sources[1])
                    else
                        if not sprite.tempCanvas then
                            sprite.tempCanvas = love.graphics.newCanvas(sprite.image:getWidth(), sprite.image:getHeight())
                        end
                        
                        local source = sprite.image
                        local target = sprite.tempCanvas
                        
                        -- 应用每个shader
                        for _, shader in ipairs(sprite.shaders.sources) do
                            love.graphics.setCanvas(target)
                            love.graphics.clear()
                            
                            love.graphics.setShader(shader)
                            love.graphics.draw(source)
                            love.graphics.setShader()
                            
                            source, target = target, source
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

                if (sprite.dust.use) then
                    love.graphics.draw(sprite.dust.image, sprite.x, sprite.y, math.rad(sprite.rotation), sprite.xscale, sprite.yscale, sprite.xpivot * sprite.width, sprite.ypivot * sprite.height, sprite.xshear, sprite.yshear)
                else
                    love.graphics.draw(sprite.image, sprite.x, sprite.y, math.rad(sprite.rotation), sprite.xscale, sprite.yscale, sprite.xpivot * sprite.width, sprite.ypivot * sprite.height, sprite.xshear, sprite.yshear)
                end

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


function sprites.CreateSpriteAtlas(path, x, y, w, h, layer)
    local sprite = sprites.CreateSprite(path, layer)
    sprite.quad = love.graphics.newQuad(x, y, w, h, sprite.image:getDimensions())
    sprite.quadArea = {
        x = x,
        y = y,
        w = w,
        h = h
    }
    sprite.xpivot = (x + w / 2) / sprite.width
    sprite.ypivot = (y + h / 2) / sprite.height

    function sprite:Draw()
        if (self.isactive) then
            love.graphics.push()

                if (not sprite.shaders.use or #sprite.shaders.sources <= 1) then
                    if (sprite.shaders.use and #sprite.shaders.sources == 1) then
                        love.graphics.setShader(sprite.shaders.sources[1])
                    else
                        if not sprite.tempCanvas then
                            sprite.tempCanvas = love.graphics.newCanvas(sprite.image:getWidth(), sprite.image:getHeight())
                        end
                        
                        local source = sprite.image
                        local target = sprite.tempCanvas
                        
                        -- 应用每个shader
                        for _, shader in ipairs(sprite.shaders.sources) do
                            love.graphics.setCanvas(target)
                            love.graphics.clear()
                            
                            love.graphics.setShader(shader)
                            love.graphics.draw(source)
                            love.graphics.setShader()
                            
                            source, target = target, source
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

                sprite.width = sprite.quadArea.w
                sprite.height = sprite.quadArea.h

                if (sprite.dust.use) then
                    love.graphics.draw(sprite.dust.image, sprite.quad, sprite.x, sprite.y, math.rad(sprite.rotation), sprite.xscale, sprite.yscale, sprite.xpivot * sprite.width, sprite.ypivot * sprite.height, sprite.xshear, sprite.yshear)
                else
                    love.graphics.draw(sprite.image, sprite.quad, sprite.x, sprite.y, math.rad(sprite.rotation), sprite.xscale, sprite.yscale, sprite.xpivot * sprite.width, sprite.ypivot * sprite.height, sprite.xshear, sprite.yshear)
                end

                if (sprite.dust.use) then
                    love.graphics.setShader()
                end

                masks.reset()
                love.graphics.setShader()
                
            love.graphics.pop()
        end
    end

    return sprite
end

function sprites.Update(dt)
    for _, sprite in ipairs(sprites.images) do
        local prevX, prevY = sprite.x, sprite.y

        sprite.x = sprite.x + sprite.velocity.x
        sprite.y = sprite.y + sprite.velocity.y

        sprite.speed.x = sprite.x - prevX
        sprite.speed.y = sprite.y - prevY

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
            local time_rate = sprite.dust.time / sprite.dust.totaltime

            local shader = sprite.dust.shader
            shader:send("dt", dt)
            if (time_rate <= 1.0) then
                --local position_rate = time_rate * time_rate * (3 - 2 * time_rate)
                local position_rate = time_rate * time_rate * time_rate * (time_rate * (time_rate * 6 - 15) + 10)
                shader:send("scan_y", position_rate)
                love.graphics.setCanvas(sprite.dust.iter_image)
                    love.graphics.clear()
                    love.graphics.setShader(shader)
                        love.graphics.draw(sprite.dust.image)
                    love.graphics.setShader()
                love.graphics.setCanvas()
                sprite.dust.image, sprite.dust.iter_image = sprite.dust.iter_image, sprite.dust.image
            end
            
            if (time_rate >= 1.0) then
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