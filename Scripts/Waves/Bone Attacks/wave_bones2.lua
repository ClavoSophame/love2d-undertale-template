local wave = {
    ENDED = false,
    objects = {}
}

local function EndWave()
    wave.ENDED = true
    arenas.clear()
    for i = #wave.objects, 1, -1 do
        local obj = wave.objects[i]
        obj:Destroy()
        table.remove(wave.objects, i)
    end
end

local bones = require("Scripts.Libraries.Attacks.Bones")

battle.mainarena:Resize(130, 130)
battle.Player.sprite:MoveTo(320, 320)
battle.Player.canMove = false

local mask = masks.New("rectangle", 320, 320, 155, 130, 0, 1)

local time = 0
local finlen = 0
function wave.update(dt)
    bones:Update()
    mask:Follow(battle.mainarena.black)

    time = time + 1
    print("Time: " .. time)
    if (time == 30) then
        battle.Player.canMove = true
        battle.Player.SetSoul(6)
        battle.Player.BlueSlamAuto(0)
    end
    if (time == 50) then
        -- battle.Player.SetSoul(1)
    end
    if (time == 30) then
        local bone = bones:New2D("Sans", 0)
        bone.position.x = 320 - 6
        bone.position.y = 400
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Quad", "Out", bone.length, 100, 10
        )
        tween.CreateTween(
            function (value)
                bone.position.y = value
            end,
            "Back", "In", 400, 640, 40
        )
        tween.CreateTween(
            function (value)
                bone.rotation = value
            end,
            "Quad", "Out", 0, -20, 30
        )
        bone.logic = function (self)
            self.position.x = self.position.x - 1.5
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone.position.x = 320 + 6
        bone.position.y = 400
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Quad", "Out", bone.length, 100, 10
        )
        tween.CreateTween(
            function (value)
                bone.position.y = value
            end,
            "Back", "In", 400, 640, 40
        )
        tween.CreateTween(
            function (value)
                bone.rotation = value
            end,
            "Quad", "Out", 0, 20, 30
        )
        bone.logic = function (self)
            self.position.x = self.position.x + 1.5
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 350)
        bone.position = {
            x = 220,
            y = 240
        }
        bone:SetMode("orange")
        bone:SetColor({1, 0.5, 0})
        bone.rotation = 90
        bone:SetStencils({mask})
        bone.__speed = 4.5
        bone.__g = 0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            if (self.rotation > 0) then
                self.rotation = self.rotation + self.__speed
            end
            if (time == 50) then
                bone:SetMode("blue")
                bone:SetColor({0, 1, 1})
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 350)
        bone.position = {
            x = 420,
            y = 240
        }
        bone:SetMode("orange")
        bone:SetColor({1, 0.5, 0})
        bone.rotation = 90
        bone:SetStencils({mask})
        bone.__speed = -4.5
        bone.__g = -0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            if (self.rotation < 180) then
                self.rotation = self.rotation + self.__speed
            end
            if (time == 50) then
                bone:SetMode("blue")
                bone:SetColor({0, 1, 1})
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 20)
        bone.position.x = 220
        bone:SetStencils({mask})
        bone:ToDown(battle.mainarena)
        bone.__speed = 7.2
        bone.__g = 0.2
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 40, 30
        )
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x + self.__speed
            self:ToDown(battle.mainarena)
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 20)
        bone.position.x = 420
        bone:SetStencils({mask})
        bone:ToDown(battle.mainarena)
        bone.__speed = -7.2
        bone.__g = -0.2
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 40, 30
        )
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x + self.__speed
            self:ToDown(battle.mainarena)
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 130 - 12)
        bone.position.x = 320
        bone.position.y = 400
        bone.rotation = 90
        bone:SetStencils({mask})
        bone.__speed = 4
        bone.__g = 0.15
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            if (self.position.y < 480) then
                self.position.y = self.position.y - self.__speed
            end
        end
        table.insert(wave.objects, bone)


        local bone = bones:New2D("Sans", 0)
        bone.position = {
            x = 320,
            y = 240
        }
        bone:SetMode("blue")
        bone:SetColor({0, 1, 1})
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 80, 30
        )
        bone.__speed = 0
        bone.__g = 0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation + 4
            self.position.x = self.position.x + self.__speed
            self.position.y = self.position.y + 2
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone.rotation = 90
        bone.position = {
            x = 320,
            y = 240
        }
        bone:SetMode("blue")
        bone:SetColor({0, 1, 1})
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 80, 30
        )
        bone.__speed = 0
        bone.__g = 0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation + 4
            self.position.x = self.position.x + self.__speed
            self.position.y = self.position.y + 2
        end
        table.insert(wave.objects, bone)


        local bone = bones:New2D("Sans", 0)
        bone.position = {
            x = 320,
            y = 240
        }
        bone:SetMode("blue")
        bone:SetColor({0, 1, 1})
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 80, 30
        )
        bone.__speed = 0
        bone.__g = 0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation - 4
            self.position.x = self.position.x - self.__speed
            self.position.y = self.position.y + 2
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone.rotation = 90
        bone.position = {
            x = 320,
            y = 240
        }
        bone:SetMode("blue")
        bone:SetColor({0, 1, 1})
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 80, 30
        )
        bone.__speed = 0
        bone.__g = 0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation - 4
            self.position.x = self.position.x - self.__speed
            self.position.y = self.position.y + 2
        end
        table.insert(wave.objects, bone)
    end
    if (time == 50) then
        local bone = bones:New2D("Sans", 350)
        bone.position = {
            x = 220,
            y = 240
        }
        bone:SetMode("orange")
        bone:SetColor({1, 0.5, 0})
        bone.rotation = 90
        bone:SetStencils({mask})
        bone.__speed = 5
        bone.__g = 0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            if (self.rotation > 0) then
                self.rotation = self.rotation + self.__speed
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 350)
        bone.position = {
            x = 420,
            y = 240
        }
        bone:SetMode("orange")
        bone:SetColor({1, 0.5, 0})
        bone.rotation = 90
        bone:SetStencils({mask})
        bone.__speed = -5
        bone.__g = -0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            if (self.rotation < 180) then
                self.rotation = self.rotation + self.__speed
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 140)
        bone:SetStencils({mask})
        bone.position.x = 320
        bone.position.y = 240
        bone.rotation = 90
        tween.CreateTween(
            function (value)
                bone.rotation = value
            end,
            "Back", "Out", bone.rotation, 0, 60
        )
        bone.logic = function (self)
            if (time >= 65 and time <= 140) then
                self.position.y = self.position.y - 2
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 140)
        bone:SetStencils({mask})
        bone.position.x = 320
        bone.position.y = 240
        bone.rotation = 270
        tween.CreateTween(
            function (value)
                bone.rotation = value
            end,
            "Back", "Out", bone.rotation, 360, 60
        )
        bone.logic = function (self)
            if (time >= 65 and time <= 140) then
                self.position.y = self.position.y - 2
            end
        end
        table.insert(wave.objects, bone)
    end

    if (time == 80) then
        local bone = bones:New2D("Sans", 0)
        bone.position = {
            x = 260,
            y = 240
        }
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Quad", "Out", bone.length, 40, 30
        )
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Bounce", "Out", bone.position.x, 320 + 65 - 6, 60
        )
        bone.__time = 0
        bone.logic = function(self)
            self.__time = self.__time + 1
            self:ToUp(battle.mainarena)

            if (time >= 130) then
                self.length = self.length + (60 - self.length) * 0.1
                self.position.x = self.position.x - (time - 130) * 0.1
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone.position = {
            x = 260,
            y = 240
        }
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Quad", "Out", bone.length, 40, 30
        )
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Bounce", "Out", bone.position.x, 320 + 65 - 6, 60
        )
        bone.__time = 0
        bone.logic = function(self)
            self.__time = self.__time + 1
            self:ToDown(battle.mainarena)

            if (time >= 130) then
                self.length = self.length + (20 - self.length) * 0.1
                self.position.x = self.position.x - (time - 130) * 0.1
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone.position = {
            x = 380,
            y = 240
        }
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Quad", "Out", bone.length, 40, 30
        )
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Bounce", "Out", bone.position.x, 320 - 65 + 6, 60
        )
        bone.__time = 0
        bone.logic = function(self)
            self.__time = self.__time + 1
            self:ToUp(battle.mainarena)

            if (time >= 130) then
                self.length = self.length + (60 - self.length) * 0.1
                self.position.x = self.position.x + (time - 130) * 0.1
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone.position = {
            x = 380,
            y = 240
        }
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Quad", "Out", bone.length, 40, 30
        )
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Bounce", "Out", bone.position.x, 320 - 65 + 6, 60
        )
        bone.__time = 0
        bone.logic = function(self)
            self.__time = self.__time + 1
            self:ToDown(battle.mainarena)

            if (time >= 130) then
                self.length = self.length + (20 - self.length) * 0.1
                self.position.x = self.position.x + (time - 130) * 0.1
            end
        end
        table.insert(wave.objects, bone)
    end

    if (time == 120) then
        local bone = bones:New2D("Sans", 0)
        bone.position = {
            x = 320,
            y = 400
        }
        bone:SetStencils({mask})
        bone.__speed = 12
        bone.__g = 0.5
        bone.__time = 0
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            if (self.length >= 0) then
                self.length = self.length + self.__speed
            end
        end
        table.insert(wave.objects, bone)
    end
    if (time == 160) then
        local gb = blasters:New(
            {320, -50}, {320, 240},
            {180, 0},

            40, 10
        )
        gb.blaster.xscale = 1
    end
    if (time == 180) then

        local bone = bones:New2D("Sans", 250)
        bone.position = {
            x = 250,
            y = 400
        }
        bone.rotation = 90
        bone:SetStencils({mask})
        bone.__speed = 4
        bone.__g = 0.2
        bone.__time = 0
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            if (self.rotation <= 90) then
                self.rotation = self.rotation - self.__speed
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 250)
        bone.position = {
            x = 390,
            y = 400
        }
        bone.rotation = 90
        bone:SetStencils({mask})
        bone.__speed = -4
        bone.__g = -0.2
        bone.__time = 0
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            if (self.rotation >= 90) then
                self.rotation = self.rotation - self.__speed
            end
        end
        table.insert(wave.objects, bone)
    end

    if (time == 220 or time == 320) then
        local bone = bones:New2D("Sans", 30)
        bone.position = {
            x = 220,
            y = 240
        }
        bone:ToUp(battle.mainarena)
        bone:SetStencils({mask})

        bone.__speed = 9.7
        bone.__g = 0.3
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation + 6
            self.position.x = self.position.x + self.__speed
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 30)
        bone.position = {
            x = 220,
            y = 240
        }
        bone:ToUp(battle.mainarena)
        bone:SetStencils({mask})
        bone.rotation = 90

        bone.__speed = 9.7
        bone.__g = 0.3
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation + 6
            self.position.x = self.position.x + self.__speed
        end
        table.insert(wave.objects, bone)


        local bone = bones:New2D("Sans", 30)
        bone.position = {
            x = 420,
            y = 240
        }
        bone:ToUp(battle.mainarena)
        bone:SetStencils({mask})

        bone.__speed = -9.7
        bone.__g = -0.3
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation - 6
            self.position.x = self.position.x + self.__speed
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 30)
        bone.position = {
            x = 420,
            y = 240
        }
        bone:ToUp(battle.mainarena)
        bone:SetStencils({mask})
        bone.rotation = 90

        bone.__speed = -9.7
        bone.__g = -0.3
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation - 6
            self.position.x = self.position.x + self.__speed
        end
        table.insert(wave.objects, bone)
    end

    if (time == 500) then
        EndWave()
    end

    if (time == 250) then
        local bone = bones:New2D("Sans", 10)
        bone.position = {
            x = 320,
            y = 240
        }
        bone:SetStencils({mask})
        bone:SetMode("blue")
        bone:SetColor({0, 1, 1})
        bone.__speed = 4
        bone.__g = 0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation - 4
            self.position.x = self.position.x + self.__speed
            self.position.y = self.position.y + 2
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 10)
        bone.position = {
            x = 320,
            y = 240
        }
        bone:SetStencils({mask})
        bone:SetMode("blue")
        bone:SetColor({0, 1, 1})
        bone.__speed = -4
        bone.__g = -0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation + 4
            self.position.x = self.position.x + self.__speed
            self.position.y = self.position.y + 2
        end
        table.insert(wave.objects, bone)
    end
    if (time == 270) then
        local bone = bones:New2D("Sans", 10)
        bone.position = {
            x = 320,
            y = 240
        }
        bone:SetStencils({mask})
        bone:SetMode("orange")
        bone:SetColor({1, 0.5, 0})
        bone.__speed = 3
        bone.__g = 0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation - 4
            self.position.x = self.position.x + self.__speed
            self.position.y = self.position.y + 2
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 10)
        bone.position = {
            x = 320,
            y = 240
        }
        bone:SetStencils({mask})
        bone:SetMode("orange")
        bone:SetColor({1, 0.5, 0})
        bone.__speed = -3
        bone.__g = -0.2
        bone.logic = function(self)
            self.__speed = self.__speed - self.__g
            self.rotation = self.rotation + 4
            self.position.x = self.position.x + self.__speed
            self.position.y = self.position.y + 2
        end
        table.insert(wave.objects, bone)
    end
    
    if (time == 200) then
        battle.Player.BlueSlamAuto(180)

        local bone = bones:New2D("Sans", 20)
        bone.position = {
            x = 220,
            y = 240
        }
        bone:SetStencils({mask})
        bone:ToUp(battle.mainarena)
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "Out", bone.position.x, 320 + 65 - 6, 30
        )
        bone.logic = function(self)
            if (time == 240) then
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Bounce", "Out", self.position.y, 320 + 65 - 16, 40
                )
            elseif (time == 280) then
                tween.CreateTween(
                    function (value)
                        self.position.x = value
                    end,
                    "Bounce", "Out", self.position.x, 320 + 10, 30
                )
            elseif (time == 310) then
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Bounce", "Out", self.length, 130 - 12, 30
                )
            elseif (time >= 310 and time <= 350) then
                self:ToDown(battle.mainarena)
            elseif (time == 400) then
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Quad", "Out", self.position.y, 0, 80
                )
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 20)
        bone.position = {
            x = 420,
            y = 240
        }
        bone:SetStencils({mask})
        bone:ToUp(battle.mainarena)
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "Out", bone.position.x, 320 - 65 + 6, 30
        )
        bone.logic = function(self)
            if (time == 240) then
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Bounce", "Out", self.position.y, 320 + 65 - 16, 40
                )
            elseif (time == 280) then
                tween.CreateTween(
                    function (value)
                        self.position.x = value
                    end,
                    "Bounce", "Out", self.position.x, 320 - 10, 30
                )
            elseif (time == 310) then
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Bounce", "Out", self.length, 130 - 12, 30
                )
            elseif (time >= 310 and time <= 350) then
                self:ToDown(battle.mainarena)
            elseif (time == 400) then
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Quad", "Out", self.position.y, 0, 80
                )
            end
        end
        table.insert(wave.objects, bone)


        for i = 1, 7
        do
            local bone = bones:New2D("Sans", 0)
            bone.position = {
                x = 240 + 20 * i,
                y = 240
            }
            bone:SetStencils({mask})
            tween.CreateTween(
                function (value)
                    bone.length = value
                end,
                "Back", "Out", bone.length, 40, 30
            )
            bone.logic = function(self)
                if (time == 230 + i) then
                    tween.CreateTween(
                        function (value)
                            self.length = value
                        end,
                        "Quad", "Out", self.length, 160, 30
                    )
                elseif (time == 320 + i) then
                    tween.CreateTween(
                        function (value)
                            self.length = value
                        end,
                        "Quad", "Out", self.length, 0, 30
                    )
                end
            end
            table.insert(wave.objects, bone)
        end
    end

    for i = #wave.objects, 1, -1 do
        local obj = wave.objects[i]
        if (obj.logic) then
            obj:logic(dt)
        end
    end
end

function wave.draw()
end

return wave