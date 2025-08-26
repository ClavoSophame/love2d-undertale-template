local timer = {}

local function createWaitFunction(t)
    return function(seconds)
        t.delay = seconds
        t.time = 0
        coroutine.yield()
    end
end

--[[
创建可等待的块函数
参数 func: 包含wait调用的函数
用法示例:
timer.CreateBlock(
    function()
        print("立即执行")
        wait(2) -- 等待2秒
        print("2秒后执行")
        wait(1) -- 再等待1秒
        print("总计3秒后执行")
    end
)
]]

---Creates a block function.
---@param func function
---@return table
function timer.CreateBlock(func)
    local t = {
        active = true,
        time = 0,
        delay = 0,
        co = nil
    }

    local wait = createWaitFunction(t)

    local co_func = function()
        _G.wait = wait
        func()
        _G.wait = nil
    end

    t.co = coroutine.create(co_func)

    t.func = function()
        local success, err = coroutine.resume(t.co)
        if not success then
            print("协程错误: "..tostring(err))
            t.active = false
        elseif coroutine.status(t.co) == "dead" then
            t.active = false
        end
    end

    t.func()

    setmetatable(t, {__index = timer})
    table.insert(timer, t)
    return t
end

function timer.Update(dt)
    for i = #timer, 1, -1 do
        local t = timer[i]
        if t.active then
            t.time = t.time + dt
            if t.time >= t.delay then
                t.func()
            end
        else
            table.remove(timer, i)
        end
    end
end

return timer