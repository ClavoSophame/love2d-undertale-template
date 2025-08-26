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

local mask = masks.New("rectangle", 320, 320, 155, 130, 0, 1)

local time = 0
local p1 = 0

function wave.update(dt)
    bones:Update()
    mask:Follow(battle.mainarena.black)

    time = time + 1
    print("Time: " .. time)

    if (time == 30) then
        local bone = bones:New2D("Sans", 118)
        bone.position.x = 225
        bone.position.y = 320
        bone.rotation = 30
        bone:SetStencils({mask})
        bone.__speed = 7
        bone.__g = 0.3
        bone.logic = function (self)
            self.rotation = self.rotation + (0 - self.rotation) * 0.1
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x + self.__speed
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 118)
        bone.position.x = 415
        bone.position.y = 320
        bone.rotation = 30
        bone:SetStencils({mask})
        bone.__speed = -7
        bone.__g = -0.3
        bone.logic = function (self)
            self.rotation = self.rotation + (0 - self.rotation) * 0.1
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x + self.__speed
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 44)
        bone.position.y = 240
        bone.rotation = 90
        bone:SetStencils({mask})
        bone.position.x = 282
        tween.CreateTween(
            function (value)
                bone.position.y = value
            end,
            "Quad", "In", 240, 400, 40
        )

        local bone = bones:New2D("Sans", 44)
        bone.position.y = 400
        bone.rotation = 90
        bone:SetStencils({mask})
        bone.position.x = 358
        tween.CreateTween(
            function (value)
                bone.position.y = value
            end,
            "Quad", "In", 400, 240, 40
        )

        local bone = bones:New2D("Sans", 0)
        bone:SetMode("orange")
        bone:SetColor({1, 0.5, 0})
        bone.position.y = 400
        bone:SetStencils({mask})
        bone.position.x = 220
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 65 - 12, 60
        )
        bone.logic = function (self)
            self.position.x = self.position.x + 4
            self:ToDown(battle.mainarena)
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone:SetMode("blue")
        bone:SetColor({0, 1, 1})
        bone.position.y = 400
        bone:SetStencils({mask})
        bone.position.x = 180
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 65 - 12, 60
        )
        bone.logic = function (self)
            self.position.x = self.position.x + 4
            self:ToDown(battle.mainarena)
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone.position.y = 400
        bone:SetStencils({mask})
        bone.position.x = 140
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 65 - 12, 60
        )
        bone.logic = function (self)
            self.position.x = self.position.x + 4
            self:ToDown(battle.mainarena)
        end
        table.insert(wave.objects, bone)




        local bone = bones:New2D("Sans", 0)
        bone:SetMode("orange")
        bone:SetColor({1, 0.5, 0})
        bone.position.y = 400
        bone:SetStencils({mask})
        bone.position.x = 420
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 65 - 12, 60
        )
        bone.logic = function (self)
            self.position.x = self.position.x - 4
            self:ToUp(battle.mainarena)
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone:SetMode("blue")
        bone:SetColor({0, 1, 1})
        bone.position.y = 400
        bone:SetStencils({mask})
        bone.position.x = 460
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 65 - 12, 60
        )
        bone.logic = function (self)
            self.position.x = self.position.x - 4
            self:ToUp(battle.mainarena)
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone.position.y = 400
        bone:SetStencils({mask})
        bone.position.x = 500
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Bounce", "Out", bone.length, 65 - 12, 60
        )
        bone.logic = function (self)
            self.position.x = self.position.x - 4
            self:ToUp(battle.mainarena)
        end
        table.insert(wave.objects, bone)



        local bone = bones:New2D("Sans", 20)
        bone:SetStencils({mask})
        bone.position.x = 420
        bone.position.y = 400
        bone.__speed = 9
        bone.__g = 0.3
        bone.logic = function (self)
            self.rotation = self.rotation - 6
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x - self.__speed
            self.position.y = self.position.y - 3
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 20)
        bone:SetStencils({mask})
        bone.position.x = 220
        bone.position.y = 240
        bone.__speed = -9
        bone.__g = -0.3
        bone.logic = function (self)
            self.rotation = self.rotation - 6
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x - self.__speed
            self.position.y = self.position.y + 3
        end
        table.insert(wave.objects, bone)
    end
    if (time == 80) then
        battle.Player.SetSoul(6)
        battle.Player.BlueSlamAuto(0)
    end
    if (time == 85) then
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

        local bone = bones:New2D("Sans", 20)
        bone:SetStencils({mask})
        bone.position.x = 320
        bone.position.y = 400
        bone.__speed = 6
        bone.__g = 0.3
        bone.logic = function (self)
            self.rotation = self.rotation - 7
            self.__speed = self.__speed - self.__g
            self.position.y = self.position.y - self.__speed
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
            if (time >= 100 and time <= 140) then
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
            if (time >= 100 and time <= 140) then
                self.position.y = self.position.y - 2
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 40)
        bone:SetStencils({mask})
        bone.rotation = 90
        bone.position.x = 280
        bone.position.y = 400
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "In", bone.position.x, 140, 60
        )
        bone.logic = function (self)
            self.position.y = self.position.y - 5
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 40)
        bone:SetStencils({mask})
        bone.rotation = 90
        bone.position.x = 360
        bone.position.y = 400
        tween.CreateTween(
            function (value)
                bone.position.x = value
            end,
            "Quad", "In", bone.position.x, 460, 60
        )
        bone.logic = function (self)
            self.position.y = self.position.y - 5
        end
        table.insert(wave.objects, bone)
    end

    if (time == 90) then
        local bone = bones:New2D("Sans", 65 - 12)
        bone:SetStencils({mask})
        bone:SetMode("orange")
        bone:SetColor({1, 0.5, 0})
        bone.position.x = 420
        bone.__speed = 7
        bone.__g = 0.2
        bone.logic = function (self)
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x - self.__speed
            self:ToDown(battle.mainarena)
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 65 - 12)
        bone:SetStencils({mask})
        bone:SetMode("orange")
        bone:SetColor({1, 0.5, 0})
        bone.position.x = 220
        bone.__speed = -7
        bone.__g = -0.2
        bone.logic = function (self)
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x - self.__speed
            self:ToDown(battle.mainarena)
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 65 - 12)
        bone:SetStencils({mask})
        bone:SetMode("blue")
        bone:SetColor({0, 1, 1})
        bone.position.x = 420
        bone.__speed = 7
        bone.__g = 0.2
        bone.logic = function (self)
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x - self.__speed
            self:ToUp(battle.mainarena)
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 65 - 12)
        bone:SetStencils({mask})
        bone:SetMode("blue")
        bone:SetColor({0, 1, 1})
        bone.position.x = 220
        bone.__speed = -7
        bone.__g = -0.2
        bone.logic = function (self)
            self.__speed = self.__speed - self.__g
            self.position.x = self.position.x - self.__speed
            self:ToUp(battle.mainarena)
        end
        table.insert(wave.objects, bone)
    end

    if (time == 110) then
        local bone = bones:New2D("Sans", 130 - 12 - 32 - 10)
        bone:SetStencils({mask})
        bone.rotation = 90
        bone.position.x = 320
        bone.position.y = 400
        bone.__speed = 8
        bone.__g = 0.3
        bone.__time = 0
        bone.logic = function (self)
            if (time <= 130) then
                self.__speed = self.__speed - self.__g
                self.position.y = self.position.y - self.__speed
            end
            if (time == 130) then
                tween.CreateTween(
                    function (value)
                        self.rotation = value
                    end,
                    "Quad", "Out", self.rotation, 0, 20
                )
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Quad", "Out", self.length, 30, 20
                )
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Quad", "Out", self.position.y, 276, 30
                )
            end
            if (time >= 130) then
                self.__time = self.__time + 1
            end
            if (time >= 130 and time <= 180) then
                self.position.x = 320 - math.sin(math.rad(self.__time * 4)) * (65 - 6)
            elseif (time > 180) then
                self.position.x = self.position.x + 5
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 130 - 12 - 32 - 10)
        bone:SetStencils({mask})
        bone.rotation = 90
        bone.position.x = 320
        bone.position.y = 240
        bone.__speed = -8
        bone.__g = -0.3
        bone.__time = 0
        bone.logic = function (self)
            if (time <= 130) then
                self.__speed = self.__speed - self.__g
                self.position.y = self.position.y - self.__speed
            end
            if (time == 130) then
                tween.CreateTween(
                    function (value)
                        self.rotation = value
                    end,
                    "Quad", "Out", self.rotation, 0, 20
                )
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Quad", "Out", self.length, 30, 20
                )
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Quad", "Out", self.position.y, 276, 30
                )
            end
            if (time >= 130) then
                self.__time = self.__time + 1
            end
            if (time >= 130 and time <= 180) then
                self.position.x = 320 + math.sin(math.rad(self.__time * 4)) * (65 - 6)
            elseif (time > 180) then
                self.position.x = self.position.x - 5
            end
        end
        table.insert(wave.objects, bone)
    end
    if (time == 120) then
        battle.Player.BlueSlamAuto(180)
    end
    if (time >= 200 and time % 1 == 0 and time <= 220) then
        p1 = p1 + 1

        local bone = bones:New2D("Sans", 0)
        bone:SetStencils({mask})
        bone.rotation = 90
        bone.position.x = 220
        bone.position.y = 400 - p1 * 12
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Quad", "Out", bone.length, 100, 30
        )
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone:SetStencils({mask})
        bone.rotation = 0
        bone.position.x = 220 + p1 * 12
        bone.position.y = 420
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Quad", "Out", bone.length, 100, 30
        )
        bone.logic = function (self)
            if (time >= 360 and time <= 400) then
                self.position.y = self.position.y + 3
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone:SetStencils({mask})
        bone.rotation = 90
        bone.position.x = 420
        bone.position.y = 400 - p1 * 12
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Quad", "Out", bone.length, 100, 30
        )
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone:SetStencils({mask})
        bone.rotation = 0
        bone.position.x = 220 + p1 * 12
        bone.position.y = 220
        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Quad", "Out", bone.length, 100, 30
        )
        bone.logic = function (self)
            if (time >= 360 and time <= 400) then
                self.position.y = self.position.y - 3
            end
        end
        table.insert(wave.objects, bone)
    end
    if (time >= 210 and time % 20 == 0 and time <= 210 + 20 * 4) then
        local bone = bones:New2D("Sans", 0)
        bone:SetStencils({mask})
        bone.rotation = 45
        bone.position.x = 320 - 100 * math.cos(math.rad(45)) + 150 * math.cos(math.rad(45))
        bone.position.y = 320 + 100 * math.sin(math.rad(45)) + 150 * math.sin(math.rad(45))

        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Back", "Out", bone.length, 200, 30
        )

        bone.logic = function (self)
            self.position.x = self.position.x - 3
            self.position.y = self.position.y - 3
            if (self.position.x < 100) then
                self:Destroy()
                for i = #wave.objects, 1, -1 do
                    if (wave.objects[i] == self) then
                        table.remove(wave.objects, i)
                        break
                    end
                end
            end
        end
        table.insert(wave.objects, bone)


        local bone = bones:New2D("Sans", 0)
        bone:SetStencils({mask})
        bone.rotation = 45
        bone.position.x = 320 + 100 * math.cos(math.rad(45)) - 150 * math.cos(math.rad(45))
        bone.position.y = 320 - 100 * math.sin(math.rad(45)) - 150 * math.sin(math.rad(45))

        tween.CreateTween(
            function (value)
                bone.length = value
            end,
            "Back", "Out", bone.length, 160, 30
        )

        bone.logic = function (self)
            self.position.x = self.position.x + 3
            self.position.y = self.position.y + 3
            if (self.position.x > 500) then
                self:Destroy()
                for i = #wave.objects, 1, -1 do
                    if (wave.objects[i] == self) then
                        table.remove(wave.objects, i)
                        break
                    end
                end
            end
        end
        table.insert(wave.objects, bone)
    end
    if (time == 310) then
        local bone = bones:New2D("Sans", 0)
        bone:SetStencils({mask})
        bone.__speed = 7
        bone.__g = 0.2
        bone.__r = 100
        bone.position.x = 320 + 100 * math.cos(math.rad(45))
        bone.position.y = 320 - 100 * math.sin(math.rad(45))
        bone.rotation = 45
        bone.logic = function (self)
            self.__speed = self.__speed - self.__g
            self.__r = self.__r - self.__speed
            if (self.length >= 0) then
                self.length = self.length + self.__speed
                self.position.x = 320 + self.__r * math.cos(math.rad(45))
                self.position.y = 320 - self.__r * math.sin(math.rad(45))
                self.rotation = self.rotation + 6
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Sans", 0)
        bone.rotation = 135
        bone:SetStencils({mask})
        bone.__speed = 7
        bone.__g = 0.2
        bone.__r = 100
        bone.position.x = 320 + 100 * math.cos(math.rad(45))
        bone.position.y = 320 - 100 * math.sin(math.rad(45))
        bone.logic = function (self)
            self.__speed = self.__speed - self.__g
            self.__r = self.__r - self.__speed
            if (self.length >= 0) then
                self.length = self.length + self.__speed
                self.position.x = 320 + self.__r * math.cos(math.rad(45))
                self.position.y = 320 - self.__r * math.sin(math.rad(45))
                self.rotation = self.rotation + 6
            end
        end
        table.insert(wave.objects, bone)
    end
    if (time == 360) then
        tween.CreateTween(
            function (value)
                _CAMERA_.rotation = value
            end,
            "Back", "Out", -45, 0, 60
        )
    end
    if (time == 360) then
        battle.Player.BlueSlamAuto(0)
    end
    if (time >= 360 and time <= 400) then
        _CAMERA_.x = _CAMERA_.x + (0 - _CAMERA_.x) * 0.1
        _CAMERA_.y = _CAMERA_.y + (0 - _CAMERA_.y) * 0.1
    end
    if (time == 200) then
        battle.Player.BlueSlamAuto(45)
        tween.CreateTween(
            function (value)
                _CAMERA_.rotation = value
            end,
            "Back", "Out", 0, -45, 60
        )
        local platform = battle.Player.BluePlatform(320 - 100 * math.cos(math.rad(45)), 320 + 100 * math.sin(math.rad(45)), global:GetVariable("LAYER"))
        platform.rotation = 45
        platform:SetStencils({mask})
        platform.color = {1, 0, 1}
        platform.xscale = 50 / 1000
        platform.__dist = 100
        tween.CreateTween(
            function (value)
                platform.__dist = value
            end,
            "Back", "Out", platform.__dist, 30, 30
        )
        platform.logic = function (self)
            if (time <= 380) then
                self.x = 320 - math.cos(math.rad(self.rotation)) * self.__dist
                self.y = 320 + math.sin(math.rad(self.rotation)) * self.__dist
            end
            if (time >= 380 and time <= 400) then
                self.x = self.x - 4
                self.y = self.y + 4
            end
        end
        table.insert(wave.objects, platform)
    end
    if (time >= 200 and time <= 240) then
        _CAMERA_.x = _CAMERA_.x + (-10 - _CAMERA_.x) * 0.1
        _CAMERA_.y = _CAMERA_.y + (80 - _CAMERA_.y) * 0.1
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