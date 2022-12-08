local L = require("insight_plugin_lang")

local tr = L.F {
    base = {
        color = "#7D4381",
        range_description = "<color=#7D4381>可触发警戒区域内的蜘蛛巢</color>"
    },
    en = {
        range_description = "<color=#7D4381>Trigger Spider Dens in Range</color>"
    }
}


local function Describe(inst, context)
    local tr = L.T(tr, context)
    return {
        name = "insight_ranged",
        priority = 0,
        description = tr.range_description,
        range = 25,
        color = tr.color,
        attach_player = false
    }

end

return { Describe = Describe }
