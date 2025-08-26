_VERSION = "2.3.9-lazy"
_RELEASED = false

function love.conf(t)
    t.identity = nil                    -- 保存目录的名称（字符串）
    t.appendidentity = false            -- 在保存目录之前搜索源目录中的文件（布尔值）
    t.version = "11.5"                  -- 此游戏制作的 LÖVE 版本（字符串）
    t.console = not _RELEASED                   -- 附加控制台（布尔值，仅限 Windows）
    t.accelerometerjoystick = true      -- 将其展现为为 Joystick ，从而启用 iOS 和 Android 上的加速度计（布尔值）
    t.externalstorage = false           -- 在 Android 上将文件保存（并从保存目录读取）在外部存储中（布尔值）
    t.gammacorrect = false              -- 当系统支持时，对渲染启用伽马校正（布尔值）

    t.audio.mic = false                 -- 在 Android 上请求并使用麦克风功能（布尔值）
    t.audio.mixwithsystem = true        -- 打开 LOVE 时保持后台音乐播放（布尔值，仅限 iOS 和 Android）

    t.window.title = "SOUL ENGINE"        -- 窗口标题（字符串）
    t.window.icon = "icon.png"          -- 用作窗口图标的图像文件路径（字符串）
    t.window.width = 640                -- 窗口宽度（数字）
    t.window.height = 480               -- 窗口高度（数字）
    t.window.borderless = false         -- 移除窗口的边框（布尔值）
    t.window.resizable = false          -- 允许窗口被用户调整大小（布尔值）
    t.window.minwidth = 1               -- 如果窗口可调整大小，窗口的最小宽度（数字）
    t.window.minheight = 1              -- 如果窗口可调整大小，窗口的最小高度（数字）
    t.window.fullscreen = false         -- 启用全屏（布尔值）
    t.window.fullscreentype = "desktop" -- 选择“桌面”全屏或“独占”全屏模式（字符串）
    t.window.vsync = 0                  -- 垂直同步模式（数字）
    t.window.msaa = 0                   -- 使用多采样抗锯齿的样本数（数字）
    t.window.depth = nil                -- 深度缓冲区中每个样本的位数
    t.window.stencil = nil              -- 模板缓冲区中每个样本的位数
    t.window.display = 1                -- 显示窗口的监视器索引（数字）
    t.window.highdpi = false            -- 在Retina显示器上启用高 DPI 模式（布尔值）
    t.window.usedpiscale = true         -- 当 highdpi 设置为 true 时启用自动 DPI 缩放（布尔值）
    t.window.dpiscale = nil
    t.window.x = nil                    -- 窗口在指定显示中的 x 坐标位置（数字）
    t.window.y = nil                    -- 窗口在指定显示中的 y 坐标位置（数字）

    t.modules.audio = true              -- 启用音频模块（布尔值）
    t.modules.data = true               -- 启用数据模块（布尔值）
    t.modules.event = true              -- 启用事件模块（布尔值）
    t.modules.font = true               -- 启用字体模块（布尔值）
    t.modules.graphics = true           -- 启用图形模块（布尔值）
    t.modules.image = true              -- 启用图像模块（布尔值）
    t.modules.joystick = true           -- 启用 Joystick 模块（布尔值）
    t.modules.keyboard = true           -- 启用键盘模块（布尔值）
    t.modules.math = true               -- 启用数学模块（布尔值）
    t.modules.mouse = true              -- 启用鼠标模块（布尔值）
    t.modules.physics = true            -- 启用物理模块（布尔值）
    t.modules.sound = true              -- 启用声音模块（布尔值）
    t.modules.system = true             -- 启用系统模块（布尔值）
    t.modules.thread = true             -- 启用线程模块（布尔值）
    t.modules.timer = true              -- 启用计时器模块（布尔值），禁用它将导致 love.update 中的 delta 时间为 0
    t.modules.touch = true              -- 启用触摸模块（布尔值）
    t.modules.video = true              -- 启用视频模块（布尔值）
    t.modules.window = true             -- 启用窗口模块（布尔值）
end

function love.errhand(msg)
    love.audio.stop()

    screen_w, screen_h = love.graphics.getDimensions()
    scale = math.min(screen_w / 640, screen_h / 480)
    draw_x = math.floor((screen_w - 640 * scale) * 0.5 + 0.5)
    draw_y = math.floor((screen_h - 480 * scale) * 0.5 + 0.5)

    msg = tostring(msg)
    local major, minor, revision = love.getVersion()
    local version_num = major * 10000 + minor * 100 + revision

    local dogangle = 0
    local dogs = {
        "spr_tinypombark_0", "spr_tinypomjump_0", "spr_tinypomsad_0", "spr_tinypomsadbark_0", "spr_tinypomwag_0",
        "spr_tinypomwag_1", "spr_tinypomwalk_0", "spr_tinypomwalk_1"
    }
    local tdog = love.graphics.newImage("Resources/Sprites/Attacks/Dogs/" .. dogs[math.random(#dogs)] .. ".png")
    tdog:setFilter("nearest", "nearest")

    local debugInfo = {
        LOVEversion = version_num,
        system = love.system.getOS(),
        time = os.date("%Y-%m-%d %H:%M:%S"),
        version = "2.3.9 - 1.0.0",
        memory = string.format("%.2f MB", collectgarbage("count") / 1024),
        renderer = love.graphics.getRendererInfo()
    }

    local debugStr = "\n\n--- DEBUG INFORMATION ---\n"
    for k, v in pairs(debugInfo) do
        debugStr = debugStr .. string.format("%s: %s\n", k, tostring(v))
    end

    debugStr = debugStr .. "\n"
    debugStr = debugStr .. "AUTHOR: [Clavo Sophame]\n"
    debugStr = debugStr .. "CONTACT: [NaN]\n"
    debugStr = debugStr .. "GAME WEBSITE: [NaN]"

    local fullError = "Fatal Error\n\n" ..
                      "Error:\n" .. msg ..
                      debugStr

    print(fullError)

    return function()
        local shouldExit = false

        love.event.pump()
        for e, a, b, c in (love.event.poll()) do
            if (e == "quit") then
                shouldExit = true
            end
        end

        if love.keyboard.isDown("lctrl", "rctrl") and love.keyboard.isDown("c") then
            love.system.setClipboardText(fullError)
        end

        if (love.graphics and love.graphics.isActive()) then
            dogangle = dogangle + 0.1
            love.graphics.reset()
            love.graphics.setColor(1, 1, 1)
            love.graphics.clear(0.15, 0.1, 0.15)

            local smallFont = love.graphics.newFont("Resources/Fonts/determination_mono.ttf", 16)
            local mainFont = love.graphics.newFont("Resources/Fonts/determination_mono.ttf", 20)

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(tdog, 200, 40, math.rad(dogangle), 1, 1, 54 / 2, 38 / 2)

            love.graphics.setFont(mainFont)
            love.graphics.setColor(1, 0.3, 0.3)
            love.graphics.print("Fatal Error", 30, 30)

            love.graphics.setColor(0.8, 0.2, 0.2)
            love.graphics.line(30, 70, love.graphics.getWidth() - 30, 70)

            love.graphics.setColor(1, 0.6, 0.6)
            love.graphics.setFont(smallFont)
            love.graphics.printf("Error:\n"..msg, 30, 85, love.graphics.getWidth() - 60)

            love.graphics.setColor(0.6, 0.8, 1)
            love.graphics.printf(debugStr, 30, 160, love.graphics.getWidth() - 60)

            love.graphics.setColor(0.5, 0.8, 0.5)
            love.graphics.printf("Press ALT+F4 quit the game", 30, love.graphics.getHeight() - 60, love.graphics.getWidth() - 60, "right")

            love.graphics.setColor(0.8, 0.8, 0.5)
            love.graphics.printf("Press CTRL+C copy the message", 30, love.graphics.getHeight() - 30, love.graphics.getWidth() - 60, "right")

            love.graphics.present()
        end

        return shouldExit
    end
end