local masks = {
    insts = {}
}

function masks.New(shape, x, y, w, h, r, value)
    local mask = {
        x = x,
        y = y,
        w = w,
        h = h,
        r = r,

        shape = shape,
        value = value,

        isactive = true
    }

    function mask:Follow(target)
        self.x = target.x
        self.y = target.y
        self.r = target.rotation
        self.w = target.width * target.xscale
        self.h = target.height * target.yscale
    end

    return mask
end

function masks.setTest(value)
    love.graphics.setStencilTest("greater", value)
end

function masks.reset()
    love.graphics.setStencilTest()
end

function masks.Draw(tableaux)
    love.graphics.push()

    love.graphics.stencil(function()
        for _, mask in pairs(tableaux)
        do
            love.graphics.push()

            local newX = mask.x
            local newY = mask.y

            love.graphics.translate(newX, newY)
            love.graphics.rotate(math.rad(mask.r))

            if (mask.shape == "rectangle") then
                love.graphics.rectangle("fill", -mask.w / 2, -mask.h / 2, mask.w, mask.h)
            elseif (mask.shape == "circle") then
                love.graphics.ellipse("fill", 0, 0, mask.w, mask.h)
            end

            love.graphics.pop()
        end
    end, "increment", 1)

    love.graphics.pop()
end

function masks.clear()
end

return masks