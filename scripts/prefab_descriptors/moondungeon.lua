local L = require("insight_plugin_lang")

local tr = L.F {
    base = {
        description = "仍需 <icon=%s> %d 次",
        actions = {
            HAMMER = "hammer",
            CHOP = "axe",
            MINE = "pickaxe",
            DIG = "shovel",
        }
    },
    en = {
        description = "<icon=%s> %d more uses needed",
    }
}

local function Describe(inst, context)
    local tr = L.T(tr, context)
    if not inst.components.workable then
        return
    end
    local workable = inst.components.workable
    local action = workable:GetWorkAction()
    local description = string.format(tr.description, tr.actions[action.id] or "pig", 5 - (inst.workTrigger % 5))
    return {
        name = "moondungeon",
        priority = 0,
        description = description,
    }
end

return { Describe = Describe }
