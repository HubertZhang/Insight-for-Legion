local L = require("insight_plugin_lang")

local tr = L.F {
        base = {
            description = "生命值: <color=HEALTH>%d</color> / <color=HEALTH>800</color>\n<color=#0FB484>吸取范围内的生命，掉落<prefab=siving_rocks>或为玄鸟补充生命值</color>"
        },
        en = {
            description = "Stored HP: <color=HEALTH>%d</color> / <color=HEALTH>800</color>\n<color=#0FB484>Drain life from nearby creatures, drop <prefab=siving_rocks> or heal Phoenix</color>"
        }
    }

local function Describe(inst, context)
    local tr = L.T(tr, context)
    local description = string.format(tr.description, inst.countHealth)
    return { priority = 0, name = "siving_thetree", description = description }
end

return { Describe = Describe }
