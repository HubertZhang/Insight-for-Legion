local tr = {
    description = "<color=WET>浇水 %d 次后发芽</color>",
}

local function Describe(inst, context)
    if inst.components.moisture then
        local moisture = inst.components.moisture:GetMoisture()
        local t = math.ceil(math.max(99 - moisture, 0) / 25)

        local description = string.format(tr.description, t)
        return {
            name = "monstrain_wizen",
            priority = 0,
            description = description
        }
    end
end

return { Describe = Describe }
