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
local p1 = 0

function wave.update(dt)
    bones:Update()
    mask:Follow(battle.mainarena.black)

    time = time + 1
    print("Time: " .. time)

    if (time == 30) then
        battle.Player.SetSoul(6)
        battle.Player.BlueSlamAuto(0)
        battle.Player.canMove = true
    end

    if (time == 30) then
        local bone = bones:New2D("Sans", 20)
        bone:ToDown(battle.mainarena)
        bone.position.x = 420
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "Out", bone.position.x, 320 - 65 + 6, 30
        )
        bone.logic = function (self)
            if (time == 60) then
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Bounce", "Out", self.position.y, 320 - 65 + 16, 20
                )
            end
            if (time == 65) then
                tween.CreateTween(
                    function (value)
                        self.position.x = value
                    end,
                    "Quad", "In", self.position.x, 430, 30
                )
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 20)
        bone:ToDown(battle.mainarena)
        bone.position.x = 220
        bone:SetStencils({mask})
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "Out", bone.position.x, 320 + 65 - 6, 30
        )
        bone.logic = function (self)
            if (time == 60) then
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Bounce", "Out", self.position.y, 320 - 65 + 16, 20
                )
            end
            if (time == 65) then
                tween.CreateTween(
                    function (value)
                        self.position.x = value
                    end,
                    "Quad", "In", self.position.x, 210, 30
                )
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 50)
        bone.position = {
            x = 320,
            y = 240
        }
        bone.rotation = 90
        bone:SetStencils({mask})

        bone.__speed = 9
        bone.__g = 0.35
        bone.logic = function (self)
            self.rotation = self.rotation + 6
            self.__speed = self.__speed - self.__g
            self.position.y = self.position.y + self.__speed

            if (time >= 50) then
                self.position.x = self.position.x + (250 - self.position.x) / 10
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 50)
        bone.position = {
            x = 320,
            y = 240
        }
        bone.rotation = 0
        bone:SetStencils({mask})

        bone.__speed = 9
        bone.__g = 0.35
        bone.logic = function (self)
            self.rotation = self.rotation + 6
            self.__speed = self.__speed - self.__g
            self.position.y = self.position.y + self.__speed

            if (time >= 50) then
                self.position.x = self.position.x + (250 - self.position.x) / 10
            end
        end
        table.insert(wave.objects, bone)


        local bone = bones:New2D("Sans", 50)
        bone.position = {
            x = 320,
            y = 240
        }
        bone.rotation = 90
        bone:SetStencils({mask})

        bone.__speed = 9
        bone.__g = 0.35
        bone.logic = function (self)
            self.rotation = self.rotation + 6
            self.__speed = self.__speed - self.__g
            self.position.y = self.position.y + self.__speed

            if (time >= 50) then
                self.position.x = self.position.x + (390 - self.position.x) / 10
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 50)
        bone.position = {
            x = 320,
            y = 240
        }
        bone.rotation = 0
        bone:SetStencils({mask})

        bone.__speed = 9
        bone.__g = 0.35
        bone.logic = function (self)
            self.rotation = self.rotation + 6
            self.__speed = self.__speed - self.__g
            self.position.y = self.position.y + self.__speed

            if (time >= 50) then
                self.position.x = self.position.x + (390 - self.position.x) / 10
            end
        end
        table.insert(wave.objects, bone)




        -- Another
        local bone = bones:New2D("Sans", 20)
        bone:ToDown(battle.mainarena)
        bone.position.x = 460
        bone:SetStencils({mask})
        bone.__speed = 8.5
        bone.__g = 0.2
        bone.logic = function (self)
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x - self.__speed
            if (time == 60) then
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Bounce", "Out", self.length, 140, 30
                )
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 20)
        bone:ToDown(battle.mainarena)
        bone.position.x = 180
        bone:SetStencils({mask})
        bone.__speed = -8.5
        bone.__g = -0.2
        bone.logic = function (self)
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x - self.__speed
            if (time == 60) then
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Bounce", "Out", self.length, 140, 30
                )
            end
        end
        table.insert(wave.objects, bone)
    end
    if (time == 60) then
        battle.Player.BlueSlamAuto(180)
    end

    if (time == 90) then
        local bone = bones:New2D("Sans", 50)
        bone:SetStencils({mask})
        bone.position.x = 420
        bone:ToUp(battle.mainarena)
        bone.__speed = 0
        bone.__g = 0.3
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "Out", bone.position.x, 320 - 25 - 6, 30
        )
        bone.logic = function (self)
            self.rotation = self.rotation + 6

            if (time >= 120) then
                self.__speed = self.__speed + self.__g
                self.position.x = self.position.x + self.__speed
                self.position.y = self.position.y + self.__speed / 2
            end
        end
        table.insert(wave.objects, bone)
        local bone = bones:New2D("Sans", 50)
        bone:SetStencils({mask})
        bone.position.x = 420
        bone.rotation = 90
        bone:ToUp(battle.mainarena)
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "Out", bone.position.x, 320 - 25 - 6, 30
        )
        bone.__speed = 0
        bone.__g = 0.3
        bone.logic = function (self)
            self.rotation = self.rotation + 6

            if (time >= 120) then
                self.__speed = self.__speed + self.__g
                self.position.x = self.position.x + self.__speed
                self.position.y = self.position.y + self.__speed / 2
            end
        end
        table.insert(wave.objects, bone)



        local bone = bones:New2D("Sans", 50)
        bone:SetStencils({mask})
        bone.position.x = 220
        bone:ToDown(battle.mainarena)
        bone.__speed = 0
        bone.__g = 0.3
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "Out", bone.position.x, 320 + 25 + 6, 30
        )
        bone.logic = function (self)
            self.rotation = self.rotation - 6

            if (time >= 120) then
                self.__speed = self.__speed - self.__g
                self.position.x = self.position.x + self.__speed
                self.position.y = self.position.y + self.__speed / 2
            end
        end
        table.insert(wave.objects, bone)
        local bone = bones:New2D("Sans", 50)
        bone:SetStencils({mask})
        bone.position.x = 220
        bone.rotation = 90
        bone:ToDown(battle.mainarena)
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "Out", bone.position.x, 320 + 25 + 6, 30
        )
        bone.__speed = 0
        bone.__g = 0.3
        bone.logic = function (self)
            self.rotation = self.rotation - 6

            if (time >= 120) then
                self.__speed = self.__speed - self.__g
                self.position.x = self.position.x + self.__speed
                self.position.y = self.position.y + self.__speed / 2
            end
        end
        table.insert(wave.objects, bone)
    end

    if (time == 120) then
        -- Another
        local bone = bones:New2D("Sans", 50)
        bone:SetStencils({mask})
        bone.position.y = 240
        bone:ToLeft(battle.mainarena)
        bone.__speed = 0
        bone.__g = 0.3
        tween.CreateTween(
            function (value)
                bone.position.y = value
            end,
            "Quad", "Out", bone.position.y, 320 + 25 + 6, 30
        )
        bone.logic = function (self)
            self.rotation = self.rotation + 6

            if (time >= 150) then
                self.__speed = self.__speed + self.__g
                self.position.x = self.position.x + self.__speed / 2
                self.position.y = self.position.y - self.__speed
            end
        end
        table.insert(wave.objects, bone)
        local bone = bones:New2D("Sans", 50)
        bone:SetStencils({mask})
        bone.position.y = 240
        bone.rotation = 90
        bone:ToLeft(battle.mainarena)
        tween.CreateTween(
            function (value)
                bone.position.y = value
            end,
            "Quad", "Out", bone.position.y, 320 + 25 + 6, 30
        )
        bone.__speed = 0
        bone.__g = 0.3
        bone.logic = function (self)
            self.rotation = self.rotation + 6

            if (time >= 150) then
                self.__speed = self.__speed + self.__g
                self.position.x = self.position.x + self.__speed / 2
                self.position.y = self.position.y - self.__speed
            end
        end
        table.insert(wave.objects, bone)


        local bone = bones:New2D("Sans", 50)
        bone:SetStencils({mask})
        bone.position.y = 400
        bone:ToRight(battle.mainarena)
        bone.__speed = 0
        bone.__g = 0.3
        tween.CreateTween(
            function (value)
                bone.position.y = value
            end,
            "Quad", "Out", bone.position.y, 320 - 25 - 6, 30
        )
        bone.logic = function (self)
            self.rotation = self.rotation - 6

            if (time >= 150) then
                self.__speed = self.__speed - self.__g
                self.position.x = self.position.x + self.__speed / 2
                self.position.y = self.position.y - self.__speed
            end
        end
        table.insert(wave.objects, bone)
        local bone = bones:New2D("Sans", 50)
        bone:SetStencils({mask})
        bone.position.y = 400
        bone.rotation = 90
        bone:ToRight(battle.mainarena)
        tween.CreateTween(
            function (value)
                bone.position.y = value
            end,
            "Quad", "Out", bone.position.y, 320 - 25 - 6, 30
        )
        bone.__speed = 0
        bone.__g = 0.3
        bone.logic = function (self)
            self.rotation = self.rotation - 6

            if (time >= 150) then
                self.__speed = self.__speed - self.__g
                self.position.x = self.position.x + self.__speed / 2
                self.position.y = self.position.y - self.__speed
            end
        end
        table.insert(wave.objects, bone)
    end

    if (time == 160) then
        battle.Player.BlueSlamAuto(0)
        tween.CreateTween(
            function (value)
                battle.mainarena.target.width = value
            end,
            "Elastic", "Out", 155, 200, 60
        )
    end

    if (time >= 180 and time % 40 == 0 and time <= 600) then
        local bone = bones:New2D("Sans", 20)
        bone.position.x = 210
        bone:SetStencils({mask})
        bone:ToDown(battle.mainarena)
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "Out", 210, 320 + 100 - 6, 60
        )
        bone.__time = 0
        bone.logic = function (self)
            self.__time = self.__time + 1
            local t = self.__time
            if (t == 60) then
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Quad", "In", 20, 130 - (20 + 12) - (12), 40
                )
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Quad", "In", self.position.y, 320 - 15, 30
                )
                tween.CreateTween(
                    function (value)
                        self.position.x = value
                    end,
                    "Quad", "In", self.position.x, 210, 60
                )
            end
        end
        table.insert(wave.objects, bone)
    end

    if (time >= 180 and time <= 600 and time % 120 == 0) then
        blasters:New(
            {0, -50}, {battle.Player.sprite.x, 240}, {180, 0},
            50, 40
        )
    end

    if (time == 800) then
        EndWave()
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