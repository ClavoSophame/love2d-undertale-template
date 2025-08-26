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

local Arena = battle.mainarena
local Player = battle.Player

local bones = require("Scripts.Libraries.Attacks.Bones")

battle.mainarena:Resize(100, 130)
battle.Player.sprite:MoveTo(320, 320)
battle.Player.canMove = true
local gb = blasters:New(
    {0, -100}, {322, 120}, {180, 0},
    50, 30
)

local mask = masks.New("rectangle", 320, 320, 155, 130, 0, 1)

local time = 0
local p1 = 0

function wave.update(dt)
    bones:Update()
    mask:Follow(battle.mainarena.black)
    battle.Player.hp = 20

    time = time + 1
    print("Time: " .. time)

    if (time == 50) then
        local bone = bones:New2D("Papyrus", 130 - 12)
        bone:ToUp(Arena)
        bone:SetColor({0, 1, 1})
        bone:SetMode("blue")
        bone:SetStencils({mask})
        bone._time = 0
        bone._gra = -5.5
        bone._g = 0.15
        bone._setted = false
        bone.logic = function (self)
            self._time = self._time + 1
            if (self._gra <= 5) then
                self._gra = self._gra + self._g
            end
            self.position.x = self.position.x + self._gra

            if (self._gra >= 0 and not self._setted) then
                self._setted = true
                self:SetColor({1, 1, 1})
                self:SetMode("normal")
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Quad", "Out", self.length, 65 - 12, 30
                )
            end
            bone:ToUp(Arena)
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Papyrus", 130 - 12)
        bone:ToUp(Arena)
        bone:SetColor({0, 1, 1})
        bone:SetMode("blue")
        bone:SetStencils({mask})
        bone._time = 0
        bone._gra = -5.5
        bone._g = 0.15
        bone._setted = false
        bone.logic = function (self)
            self._time = self._time + 1
            if (self._gra <= 5) then
                self._gra = self._gra + self._g
            end
            self.position.x = self.position.x - self._gra

            if (self._gra >= 0 and not self._setted) then
                self._setted = true
                self:SetColor({1, 1, 1})
                self:SetMode("normal")
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Quad", "Out", self.length, 65 - 12, 30
                )
            end
            bone:ToDown(Arena)
        end
        table.insert(wave.objects, bone)
    end

    if (time == 80) then
        tween.CreateTween(
            function (value)
                Arena.target.width = value
            end,
            "Bounce", "Out", Arena.width, 220, 30
        )
        Player.SetSoul(6)
        Player.BlueSlamAuto(0)
    end
    if (time % 60 == 0 and time >= 90 and time <= 270) then
        local bone = bones:New2D("Papyrus", 130 - 20 - 26)
        bone.position.x = 120
        bone:ToUp(Arena)
        bone:SetStencils({mask})
        bone.logic = function (self)
            self.position.x = self.position.x + 3
            if (time == 300) then
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Quad", "InOut", self.length, 20, 30
                )
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Bounce", "Out", self.position.y, Arena.y + Arena.height / 2 - 10 - 6, 30
                )
            end

            if (self.position.x >= 520) then
                self:Destroy()
                for i = #wave.objects, 1, -1 do
                    if (wave.objects[i] == self) then
                        table.remove(wave.objects, i)
                    end
                end
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Papyrus", 20)
        bone.position.x = 520
        bone:ToDown(Arena)
        bone:SetStencils({mask})
        bone.logic = function (self)
            self.position.x = self.position.x - 3
            if (time == 300) then
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Quad", "InOut", self.length, 130 - 20 - 26, 30
                )
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Bounce", "Out", self.position.y, Arena.y - Arena.height / 2 + (130 - 20 - 26) / 2 + 6, 30
                )
            end

            if (self.position.x <= 120) then
                self:Destroy()
                for i = #wave.objects, 1, -1 do
                    if (wave.objects[i] == self) then
                        table.remove(wave.objects, i)
                    end
                end
            end
        end
        table.insert(wave.objects, bone)
    end

    if (time % 60 == 0 and time > 270 and time <= 480) then
        local bone = bones:New2D("Papyrus", 20)
        bone.position.x = 120
        bone:ToDown(Arena)
        bone:SetStencils({mask})
        bone.logic = function (self)
            self.position.x = self.position.x + 3
            if (time == 480) then
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Quad", "InOut", self.length, 130 - 20 - 26, 30
                )
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Bounce", "Out", self.position.y, Arena.y - Arena.height / 2 + (130 - 20 - 26) / 2 + 6, 30
                )
            end

            if (self.position.x >= 520) then
                self:Destroy()
                for i = #wave.objects, 1, -1 do
                    if (wave.objects[i] == self) then
                        table.remove(wave.objects, i)
                    end
                end
            end
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Papyrus", 130 - 20 - 26)
        bone.position.x = 520
        bone:ToUp(Arena)
        bone:SetStencils({mask})
        bone.logic = function (self)
            self.position.x = self.position.x - 3
            if (time == 480) then
                tween.CreateTween(
                    function (value)
                        self.length = value
                    end,
                    "Quad", "InOut", self.length, 20, 30
                )
                tween.CreateTween(
                    function (value)
                        self.position.y = value
                    end,
                    "Bounce", "Out", self.position.y, Arena.y + Arena.height / 2 - 10 - 6, 30
                )
            end

            if (self.position.x <= 120) then
                self:Destroy()
                for i = #wave.objects, 1, -1 do
                    if (wave.objects[i] == self) then
                        table.remove(wave.objects, i)
                    end
                end
            end
        end
        table.insert(wave.objects, bone)
    end

    if (time >= 90 and time % 120 == 0 and time <= 400) then
        local bone = bones:New2D("Papyrus", 0)
        bone.position.x = Player.sprite.x
        bone.position.y = 400
        bone:SetStencils({mask})
        bone._gra = 6.2
        bone._g = 0.3
        bone.logic = function (self)
            self._gra = self._gra - self._g
            self.length = self.length + self._gra

            if (self.length < 0) then
                self:Destroy()
                for k, v in pairs(wave.objects) do
                    if v == self then
                        table.remove(wave.objects, k)
                        break
                    end
                end
            end
        end
        table.insert(wave.objects, bone)
    end

    if (time == 560) then
        tween.CreateTween(
            function (value)
                Arena.target.width = value
            end,
            "Bounce", "Out", Arena.width, 130, 30
        )
    end

    if (time == 930) then
        Player.BlueSlamAuto(180)
    end

    if (time == 580) then
        local bone = bones:New2D("Papyrus", 20)
        bone:SetStencils({mask})
        bone._time = 0
        bone._gra = 7
        bone._g = 0.2
        bone.logic = function (self)
            self._time = self._time + 1
            self.position.x = 320 + 60 * math.sin(math.rad(self._time) * 4)

            self._gra = self._gra - self._g
            self.position.y = self.position.y + self._gra
            if (self._time % 120 == 60) then
                self._g = -0.2
            elseif (self._time % 120 == 0) then
                self._g = 0.22
            end
            self.rotation = self.rotation + 3
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Papyrus", 20)
        bone:SetStencils({mask})
        bone._time = 0
        bone._gra = 7
        bone._g = 0.2
        bone.logic = function (self)
            self._time = self._time + 1
            self.position.x = 320 - 60 * math.sin(math.rad(self._time) * 4)

            self._gra = self._gra - self._g
            self.position.y = self.position.y + self._gra
            if (self._time % 120 == 60) then
                self._g = -0.2
            elseif (self._time % 120 == 0) then
                self._g = 0.22
            end
            self.rotation = self.rotation - 3
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Papyrus", 20)
        bone:SetStencils({mask})
        bone.position.y = 400
        bone._time = 0
        bone._gra = 6.5
        bone._g = 0.2
        bone.logic = function (self)
            self._time = self._time + 1
            self.position.x = 320 + 40 * math.sin(math.rad(self._time) * 6)

            self._gra = self._gra - self._g
            self.position.y = self.position.y - self._gra
            if (self._time % 120 == 60) then
                self._g = -0.2
            elseif (self._time % 120 == 0) then
                self._g = 0.22
            end
            self.rotation = self.rotation - 3
        end
        table.insert(wave.objects, bone)

        local bone = bones:New2D("Papyrus", 20)
        bone:SetStencils({mask})
        bone.position.y = 400
        bone._time = 0
        bone._gra = 6.5
        bone._g = 0.2
        bone.logic = function (self)
            self._time = self._time + 1
            self.position.x = 320 - 40 * math.sin(math.rad(self._time) * 6)

            self._gra = self._gra - self._g
            self.position.y = self.position.y - self._gra
            if (self._time % 120 == 60) then
                self._g = -0.2
            elseif (self._time % 120 == 0) then
                self._g = 0.22
            end
            self.rotation = self.rotation + 3
        end
        table.insert(wave.objects, bone)
    end

    if (time == 940) then
        local wall = bones:Wall(Arena, "Papyrus", 25, 25, 40, "left", 0, 14, {
            In = "sineOut", Out = "sineIn",
            It = 15, Ot = 15
        })
        wall:SetStencils({mask})
        table.insert(wave.objects, wall)
        local wall = bones:Wall(Arena, "Papyrus", 25, 25, 40, "right", 0, 14, {
            In = "sineOut", Out = "sineIn",
            It = 15, Ot = 15
        })
        wall:SetStencils({mask})
        table.insert(wave.objects, wall)
    end
    if (time == 960) then
        Player.BlueSlamAuto(maths.Choose(90, 270))
        local gb = blasters:New(
            {0, -100}, {322, 120}, {180, 0},
            60, 30
        )
    end

    for i = #wave.objects, 1, -1 do
        local obj = wave.objects[i]
        if (obj.logic) then
            obj:logic(dt)
        end
    end
end

return wave