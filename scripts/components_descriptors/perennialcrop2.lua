local L = require("insight_plugin_lang")

local tr = L.F {
    base = {
        pollinated = "<color=LIGHT_PINK>授粉%d次</color>",
        infested = "<color=#dd5555>侵害%d次</color>",
    },
    en = {
        pollinated = "<color=LIGHT_PINK>Pollinated %d time(s)</color>",
        infested = "<color=#dd5555>Infested %d time(s)</color>",
    }
}

local function Describe(inst, context)
    local tr = L.T(tr, context)
    local descriptions = {}
    if inst.timedata then
        if inst.timedata.paused or inst.timedata.mult == nil then
            descriptions[#descriptions + 1] = { name = "grow_time", priority = 0,
                description = context.lstr.growable.paused }
        elseif inst.timedata.start and inst.timedata.all then
            local alltime = inst.timedata.all * inst.timedata.mult
            local pass = GetTime() - inst.timedata.start
            local description = string.format(context.lstr.growable.next_stage,
                context.time:SimpleProcess(alltime - pass))
            descriptions[#descriptions + 1] = { name = "grow_time", priority = 0, description = description }
        end
    end

    if inst.pollinated or inst.infested then
        local status = {}
        status[#status + 1] = string.format(tr.pollinated, inst.pollinated)
        if inst.infested > 0 then
            status[#status + 1] = string.format(tr.infested, inst.infested)
        end
        descriptions[#descriptions + 1] = { name = "status", priority = 1, description = table.concat(status, " ") }
    end
    return unpack(descriptions)
end

return { Describe = Describe }
