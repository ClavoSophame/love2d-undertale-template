local encstep = {}

function encstep.Init(key, base, range, amount)
    encstep.key = key
    encstep.base = (base or 80)
    encstep.range = (range or 40)
    encstep.amount = (amount or 20)

    encstep.killed = encstep.key
    encstep.rho = math.min(8, encstep.amount / (encstep.amount - encstep.killed))
    encstep.target = encstep.rho * (base + math.random(range))

    encstep.time = 0
    encstep.encountered = false
    encstep.nobodycame = false
    encstep.run = true
end

function encstep.Update()
    if (not encstep.run) then return end

    if (encstep.amount > encstep.killed) then
        encstep.time = encstep.time + 1
        print(encstep.time)
        if (encstep.time >= encstep.target) then
            encstep.time = 0
            encstep.encountered = true
        end
    else
        if (not global:GetVariable("EncounterNobody")) then
            encstep.time = encstep.time + 1
            if (encstep.time >= 20) then
                global:SetVariable("EncounterNobody", true)
                encstep.rho = 999
                encstep.time = 0
                encstep.nobodycame = true
            end
        end
    end
end

return encstep