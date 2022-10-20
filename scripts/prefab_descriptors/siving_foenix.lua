local tr = {
    description = "<color=#0FB484>神木光辉 %d 层：吸收伤害 %d %%</color>"
}

local absorption = {
    1 - 0.67,
    1 - 0.33,
    1 - 0.01
}


local function Describe(inst, context)
    if inst.sign_l_treehalo then
        local left = absorption[inst.sign_l_treehalo]
        if not left then
            return
        end
        return {
            name = "absorption",
            priority = 0,
            description = string.format(tr.description, inst.sign_l_treehalo, math.floor(left * 100)),
        }
    end
end

return { Describe = Describe }
