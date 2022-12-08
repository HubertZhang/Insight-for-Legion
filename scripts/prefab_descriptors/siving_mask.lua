local L = require("insight_plugin_lang")

local tr = L.F {
    base = {
        description_1 = "存储生命值: <color=HEALTH>%d</color>",
        description_2 = " / <color=HEALTH>%d</color>"
    },
    en = {
        description_1 = "Health Stored: <color=HEALTH>%d</color>",
        description_2 = " / <color=HEALTH>%d</color>"
    }
}

local function Describe(inst, context)
    local tr = L.T(tr, context)
    if not inst.healthcounter then
        return
    end
    local description = string.format(tr.description_1, inst.healthcounter)
    if inst.healthcounter_max then
        description = description .. string.format(tr.description_2, inst.healthcounter_max)
    end
    return { priority = 0, name = "siving_mask", description = description }
end

return { Describe = Describe }
