local L = require("insight_plugin_lang")

local tr = L.F {
    base = {
        description = "<color=#0FB484>神木光辉 %d 层</color>"
    },
    en = {
        description = "<color=#0FB484>Tree Halo Lv %d</color>"
    }
}

local absorption = {
    1 - 0.67,
    1 - 0.33,
    1 - 0.01
}

local function Describe(inst, context)
    local tr = L.T(tr, context)
    if inst.sign_l_treehalo then
        local left = absorption[inst.sign_l_treehalo]
        if not left then
            return
        end
        return {
            name = "absorption",
            priority = 0,
            description = string.format(tr.description + context.lstr.absorption, inst.sign_l_treehalo,
                math.floor(left * 100)),
        }
    end
end

return { Describe = Describe }
