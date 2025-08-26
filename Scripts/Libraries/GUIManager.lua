local gui = {
    buttons = {},
    texts = {},
    text_inputs = {},
    images = {},
    sliders = {},
    checkboxes = {},
    dropdowns = {},
    progress_bars = {},
    panels = {},
}

function gui.clear()
    gui.buttons = {}
    gui.texts = {}
    gui.text_inputs = {}
    gui.images = {}
    gui.sliders = {}
    gui.checkboxes = {}
    gui.dropdowns = {}
    gui.progress_bars = {}
    gui.panels = {}
end

----BUTTONS-----

---Creates a rectangular button.
---@param x number
---@param y number
---@param width number
---@param height number
---@param text string
---@param callback function
---@return table
function gui.add_button_rect(x, y, width, height, text, callback)
    local button = {
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
        colors = {
            normal   = {1, 1, 1},
            hover    = {1, 1, 1},
            pressed  = {1, 1, 1},
            disabled = {1, 1, 1},
            font = {1, 1, 1},
        },
        font = love.graphics.getFont(),
        callback = callback
    }
    button.color = button.colors.normal

    button.draw_function = function()
        love.graphics.setColor(button.color)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
        love.graphics.setColor(button.colors.font)
        love.graphics.setFont(button.font)
        local textHeight = button.font:getHeight(button.text)
        local textY = button.y + (button.height - textHeight) / 2
        love.graphics.printf(button.text, button.x, textY, button.width, "center")
    end

    table.insert(gui.buttons, button)
    return button
end

---Creates a rounded rectangle button.
---@param x number
---@param y number
---@param width number
---@param height number
---@param radius number
---@param text string
---@param callback function
---@return table
function gui.add_button_roundrect(x, y, width, height, radius, text, callback)
    local button = gui.add_button_rect(x, y, width, height, text, callback)
    button.radius = radius
    button.draw_function = function()
        love.graphics.setColor(button.color)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height, button.radius)
        love.graphics.setColor(button.colors.font)

        love.graphics.setFont(button.font)
        local textHeight = button.font:getHeight(button.text)
        local textY = button.y + (button.height - textHeight) / 2
        love.graphics.printf(button.text, button.x, textY, button.width, "center")
    end
    return button
end

---Creates an elliptical button.
---@param x number
---@param y number
---@param width number
---@param height number
---@param text string
---@param callback function
---@return table
function gui.add_button_ellipse(x, y, width, height, text, callback)
    local button = gui.add_button_rect(x, y, width, height, text, callback)
    button.draw_function = function()
        love.graphics.setColor(button.color)
        love.graphics.ellipse("fill", button.x + button.width / 2, button.y + button.height / 2, button.width / 2, button.height / 2)
        love.graphics.setColor(button.colors.font)

        love.graphics.setFont(button.font)
        local textHeight = button.font:getHeight(button.text)
        local textY = button.y + (button.height - textHeight) / 2
        love.graphics.printf(button.text, button.x, textY, button.width, "center")
    end
    return button
end

---Creates an image button.
---@param x number
---@param y number
---@param image_path string
---@param callback function
---@return table
function gui.add_button_image(x, y, image_path, callback)
    local image = love.graphics.newImage(image_path)
    image:setFilter("nearest", "nearest")
    local button = {
        x = x,
        y = y,
        width = image:getWidth(),
        height = image:getHeight(),
        image = image,
        callback = callback,
        is_hovered = false,
        is_pressed = false,
        is_enabled = true,
        color = {1, 1, 1}
    }

    button.draw_function = function()
        love.graphics.setColor(button.color)
        love.graphics.draw(button.image, button.x, button.y)
    end

    table.insert(gui.buttons, button)
    return button
end

-----TEXTS-----

---Creates a text element.
---@param x number
---@param y number
---@param text string
---@param font userdata
---@param color table
---@return table
function gui.add_text(x, y, text, font, color)
    local txt = {
        x = x,
        y = y,
        text = text,
        font = font or love.graphics.getFont(),
        color = color or {1, 1, 1}
    }
    txt.font:setFilter("nearest", "nearest")
    txt.draw_function = function()
        love.graphics.setColor(txt.color)
        love.graphics.setFont(txt.font)
        love.graphics.print(txt.text, txt.x, txt.y)
    end
    table.insert(gui.texts, txt)
    return txt
end

-----SLIDERS-----

---Creates a slider element.
---@param x number
---@param y number
---@param width number
---@param height number
---@param min number
---@param max number
---@param value number
---@param callback function
---@param step number|nil
---@param orientation string|nil
---@param ticks boolean|nil
---@param disabled boolean|nil
---@param show_value boolean|nil
---@return table
function gui.add_slider(
    x, y,          -- 坐标（必需）
    width, height, -- 尺寸（必需）
    min, max,      -- 范围（必需）
    value,         -- 初始值（必需）
    callback,      -- 回调函数（必需）
    step,          -- 步长（可选）
    orientation,   -- 方向（可选）
    ticks,         -- 刻度（可选）
    disabled,      -- 禁用状态（可选）
    show_value     -- 显示当前值（可选）
)
    local slider = {
        x = x,
        y = y,
        width = width,
        height = height,
        min = min,
        max = max,
        value = value,
        callback = callback,
        step = step or 1,
        orientation = orientation or "horizontal",
        ticks = ticks or false,
        disabled = disabled or false,
        show_value = show_value or false
    }

    slider.draw_function = function()
        if (slider.orientation == "horizontal") then
            -- 绘制滑块背景
            love.graphics.setColor(0.7, 0.7, 0.7)
            love.graphics.rectangle("fill", slider.x, slider.y, slider.width, slider.height)

            -- 计算滑块位置
            local ratio = (slider.value - slider.min) / (slider.max - slider.min)
            local handleX = slider.x + ratio * slider.width

            -- 绘制滑块
            love.graphics.setColor(0.3, 0.3, 0.3)
            love.graphics.rectangle("fill", handleX - 5, slider.y, 10, slider.height)

            -- 显示当前值
            if slider.show_value then
                love.graphics.setColor(1, 1, 1)
                love.graphics.print(tostring(slider.value), slider.x + slider.width + 10, slider.y)
            end
        else
            -- 绘制垂直滑块背景
            love.graphics.setColor(0.7, 0.7, 0.7)
            love.graphics.rectangle("fill", slider.x, slider.y, slider.width, slider.height)

            -- 计算滑块位置
            local ratio = (slider.value - slider.min) / (slider.max - slider.min)
            local handleY = slider.y + (1 - ratio) * slider.height

            -- 绘制滑块
            love.graphics.setColor(0.3, 0.3, 0.3)
            love.graphics.rectangle("fill", slider.x, handleY - 5, slider.width, 10)

            -- 显示当前值
            if slider.show_value then
                love.graphics.setColor(1, 1, 1)
                love.graphics.print(tostring(slider.value), slider.x + slider.width + 10, slider.y)
            end
        end
    end

    table.insert(gui.sliders, slider)
    return slider
end

-----TEXT_INPUTS-----

function gui.add_text_input(x, y, width, height, placeholder, callback)
    local text_input = {
        x = x,
        y = y,
        width = width,
        height = height,
        placeholder = placeholder or "",
        text = "",
        callback = callback or function() end,
        is_focused = false,
        font = love.graphics.getFont(),
    }
    text_input.font:setFilter("nearest", "nearest")
    text_input.draw_function = function()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", text_input.x, text_input.y, text_input.width, text_input.height)
        love.graphics.setFont(text_input.font)
        local display_text = text_input.text ~= "" and text_input.text or text_input.placeholder
        love.graphics.print(display_text, text_input.x + 5, text_input.y + (text_input.height - text_input.font:getHeight()) / 2)
    end

    table.insert(gui.text_inputs, text_input)
    return text_input
end

-----TABLE AND TREE STRUCTURES-----

function gui.add_table(x, y, w, h, headers, config)
    config = config or {}
    local table_obj = {
        x = x, y = y, width = w, height = h,
        headers = headers,
        data = {},  -- 二维数组存储数据
        col_widths = {},
        row_heights = {},
        visible_rows = math.floor((h - 30) / 20),  -- 可视区域行数
        scroll_offset = 0,
        
        -- 样式配置
        colors = config.colors or {
            border = {0.8, 0.8, 0.8},
            header_bg = {0.3, 0.3, 0.5, 0.8},
            cell_bg = {0.2, 0.2, 0.2, 0.5}
        },
        font = config.font or love.graphics.getFont()
    }
    
    -- 初始化列宽（自动计算或平均分配）
    local total_header_width = 0
    for i, header in ipairs(headers) do
        local width = table_obj.font:getWidth(header) + 20
        table_obj.col_widths[i] = width
        total_header_width = total_header_width + width
    end
    
    -- 等宽分配剩余空间
    if total_header_width < w then
        local extra = (w - total_header_width) / #headers
        for i = 1, #headers do
            table_obj.col_widths[i] = table_obj.col_widths[i] + extra
        end
    end

    table.insert(gui.panels, table_obj)
    
    -- 设置元表实现面向对象访问
    return setmetatable(table_obj, {
        __index = {
            add_row = function(self, row_data)
                table.insert(self.data, row_data)
                self:_adjust_row_height(#self.data, row_data)
            end,
            
            remove_row = function(self, index)
                if index >= 1 and index <= #self.data then
                    table.remove(self.data, index)
                    table.remove(self.row_heights, index)
                end
            end,
            
            update_cell = function(self, row, col, value)
                if self.data[row] then
                    self.data[row][col] = value
                    self:_adjust_row_height(row, self.data[row])
                end
            end,
            
            _adjust_row_height = function(self, row_index, row_data)
                local max_height = 20
                for col, value in ipairs(row_data) do
                    local text = tostring(value)
                    local lines = math.ceil(table_obj.font:getWidth(text) / table_obj.col_widths[col])
                    max_height = math.max(max_height, lines * table_obj.font:getHeight() + 10)
                end
                self.row_heights[row_index] = max_height
            end,
            
            draw = function(self)
                self:_draw_border()
                self:_draw_headers()
                self:_draw_rows()
            end,
            
            _draw_border = function(self)
                love.graphics.setColor(self.colors.border)
                love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
            end,
            
            _draw_headers = function(self)
                love.graphics.setColor(self.colors.header_bg)
                love.graphics.rectangle("fill", self.x, self.y, self.width, 30)
                
                love.graphics.setColor(1, 1, 1)
                local x_pos = self.x
                for i, header in ipairs(self.headers) do
                    love.graphics.print(header, x_pos + 5, self.y + 8)
                    x_pos = x_pos + self.col_widths[i]
                end
            end,
            
            _draw_rows = function(self)
                local y_pos = self.y + 30
                local start_row = math.max(1, self.scroll_offset + 1)
                local end_row = math.min(#self.data, start_row + self.visible_rows - 1)
                
                for i = start_row, end_row do
                    local row_y = y_pos + (i - start_row) * self.row_heights[i]
                    self:_draw_row(i, self.data[i], row_y)
                end
            end,
            
            _draw_row = function(self, row_index, row_data, y_pos)
                love.graphics.setColor(self.colors.cell_bg)
                love.graphics.rectangle("fill", self.x, y_pos, self.width, self.row_heights[row_index])
                
                love.graphics.setColor(1, 1, 1)
                local x_pos = self.x
                for col, value in ipairs(row_data) do
                    love.graphics.print(tostring(value), x_pos + 5, y_pos + 5)
                    love.graphics.rectangle("line", x_pos, y_pos, self.col_widths[col], self.row_heights[row_index])
                    x_pos = x_pos + self.col_widths[col]
                end
            end
        }
    })
end

function gui.add_menu(x, y, w, h, items, functions)
    local menu = {
        x = x, y = y, width = w, height = h,
        items = items or {}
    }
    menu.activing = false
    menu.itembuttons = {}
    menu.button = gui.add_button_roundrect(x, y, w, h, 5, "", function()
        -- Placeholder for menu click actions
        menu.activing = not menu.activing
        if menu.activing then
            for i, item in ipairs(menu.items) do
                local button = gui.add_button_rect(x, y + i * (h + 5), w - 5, h, item, 
                    functions and functions[i] or function() print("Undefined buttons") end
                )
                button.colors = {
                    normal   = {0.5, 0.5, 0.5},
                    hover    = {0.7, 0.7, 0.7},
                    pressed  = {0.3, 0.3, 0.3},
                    disabled = {0.5, 0.2, 0.2},
                    font = {1, 1, 1},
                }
                table.insert(menu.itembuttons, button)
            end
        else
            for _, btn in ipairs(menu.itembuttons) do
                for i, b in ipairs(gui.buttons) do
                    if b == btn then
                        table.remove(gui.buttons, i)
                        break
                    end
                end
            end
        end
    end)
    table.insert(gui.panels, menu)
    return menu
end

---Updates the GUI elements.
---@param dt number
function gui.update(dt)
    for _, button in ipairs(gui.buttons) do
        -- Update button logic here, e.g., check for hover or click
        button.is_hovered = false
        button.is_pressed = false
        button.is_enabled = true -- You can add logic to enable/disable the button

        if not button.is_enabled then
            button.color = button.colors.disabled
            return
        end

        local mx, my = keyboard.GetMousePosition()
        local realX = mx
        local realY = my
        if realX and realY and
            realX >= button.x and realX <= button.x + button.width and
            realY >= button.y and realY <= button.y + button.height then
            button.is_hovered = true
            button.color = button.colors.hover
            if keyboard.GetState("mouse1") == 1 then
                button.is_pressed = true
                button.color = button.colors.pressed
                if button.callback then
                    button.callback()
                end
            end
        else
            button.is_hovered = false
            button.is_pressed = false
            button.color = button.colors.normal
        end
    end
    for _, slider in ipairs(gui.sliders) do
        -- Update slider logic here, e.g., check for drag
        if slider.disabled then
            return
        end

        local mx, my = keyboard.GetMousePosition()
        local realX = mx
        local realY = my
        if realX and realY and
            realX >= slider.x and realX <= slider.x + slider.width and
            realY >= slider.y and realY <= slider.y + slider.height then
            if keyboard.GetState("mouse1") >= 1 then
                if slider.orientation == "horizontal" then
                    local ratio = (realX - slider.x) / slider.width
                    local newValue = slider.min + ratio * (slider.max - slider.min)
                    if slider.step > 0 then
                        newValue = math.floor(newValue / slider.step + 0.5) * slider.step
                    end
                    newValue = math.max(slider.min, math.min(slider.max, newValue))
                    if newValue ~= slider.value then
                        slider.value = newValue
                        if slider.callback then
                            slider.callback(slider.value)
                        end
                    end
                else
                    local ratio = 1 - (realY - slider.y) / slider.height
                    local newValue = slider.min + ratio * (slider.max - slider.min)
                    if slider.step > 0 then
                        newValue = math.floor(newValue / slider.step + 0.5) * slider.step
                    end
                    newValue = math.max(slider.min, math.min(slider.max, newValue))
                    if newValue ~= slider.value then
                        slider.value = newValue
                        if slider.callback then
                            slider.callback(slider.value)
                        end
                    end
                end
            end
        end
    end
    for _, text_input in ipairs(gui.text_inputs) do
        -- Update text input logic here, e.g., check for focus and input
        if text_input.is_focused then
            local key = keyboard.ReturnLetter()
            if key then
                text_input.text = text_input.text .. key
                if text_input.callback then
                    text_input.callback(text_input.text)
                end
            end

            if keyboard.GetState("backspace") == 1 then
                text_input.text = text_input.text:sub(1, -2)
                if text_input.callback then
                    text_input.callback(text_input.text)
                end
            end

            local mx, my = keyboard.GetMousePosition()
            local realX = mx
            local realY = my
            if realX and realY and
                realX >= text_input.x and realX <= text_input.x + text_input.width and
                realY >= text_input.y and realY <= text_input.y + text_input.height then
                if (keyboard.GetState("mouse1") == 1) then
                    text_input.is_focused = true
                end
            else
                if (keyboard.GetState("mouse1") == 1) then
                    text_input.is_focused = false
                end
            end
        else
            -- Check if the text input is focused
            local mx, my = keyboard.GetMousePosition()
            local realX = mx
            local realY = my
            if realX and realY and
                realX >= text_input.x and realX <= text_input.x + text_input.width and
                realY >= text_input.y and realY <= text_input.y + text_input.height then
                if (keyboard.GetState("mouse1") == 1) then
                    text_input.is_focused = true
                end
            else
                if (keyboard.GetState("mouse1") == 1) then
                    text_input.is_focused = false
                end
            end
        end
    end
end

function gui.draw()
    for _, button in ipairs(gui.buttons) do
        button.draw_function()
    end
    for _, text in ipairs(gui.texts) do
        text.draw_function()
    end
    for _, slider in ipairs(gui.sliders) do
        slider.draw_function()
    end
    for _, text_input in ipairs(gui.text_inputs) do
        text_input.draw_function()
    end
    for _, panel in ipairs(gui.panels) do
        if panel.draw then
            panel:draw()
        end
    end
end

return gui