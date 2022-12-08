local L = require("insight_plugin_lang")

local tr = {
    base = {
        description = "<color=WET>%s</color> 后电击",
    },
    en = {
        description = "Electric Shock in <color=WET>%s</color>",
    }
}

local function Describe(inst, context)
    local tr = L.T(tr, context)
    if inst.updatetask then
        local description = string.format(tr.description,
            context.time:SimpleProcess(inst.updatetask:NextTime() - GetTime()))
        return { name = "tourmalinecore", priority = 0, description = description }
    end
end

return { Describe = Describe }
