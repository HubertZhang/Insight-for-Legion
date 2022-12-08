local L = require("insight_plugin_lang")

local tr = L.F {
    base = {
        tended = "<color=NATURE>对话%d次</color>",
        pollinated = "<color=LIGHT_PINK>授粉%d次</color>",
        sickness = "<color=MONSTER>疾病%d%%</color>",
        infested = "<color=#dd5555>侵害%d/%d次</color>",
    },
    en = {
        tended = "<color=NATURE>Tended %d time(s)</color>",
        pollinated = "<color=LIGHT_PINK>Pollinated %d time(s)</color>",
        sickness = "<color=MONSTER>Sickness %d%%</color>",
        infested = "<color=#dd5555>Infested %d/%d time(s)</color>",
    }
}

local function Describe(inst, context)
    local tr = L.T(tr, context)

    local descriptions = {}
    descriptions[#descriptions + 1] = {
        name = "perennialcrop_status",
        priority = 20,
        description = string.format(context.lstr.fertilizer.nutrient_value,
            inst.nutrientgrow, inst.nutrientsick, inst.nutrient)
    }
    descriptions[#descriptions + 1] = {
        name = "perennialcrop_status",
        priority = 10,
        description = string.format(context.lstr.farmsoildrinker.soil_only, tostring(inst.moisture))
    }

    if inst.timedata then
        if inst.timedata.paused == nil then
            descriptions[#descriptions + 1] = { name = "perennialcrop_status", priority = 100,
                description = context.lstr.growable.paused }
        elseif inst.timedata.start and inst.timedata.all then
            local alltime = inst.timedata.all
            local pass = GetTime() - inst.timedata.start
            local description = string.format(context.lstr.growable.next_stage,
                context.time:SimpleProcess(alltime - pass))
            descriptions[#descriptions + 1] = { name = "perennialcrop_status", priority = 100, description = description }
        end
    end

    local status = {}
    status[#status + 1] = string.format(tr.tended, inst.num_tended or 0)
    status[#status + 1] = string.format(tr.pollinated, inst.pollinated or 0)
    if inst.sickness > 0 then
        status[#status + 1] = string.format(tr.sickness, math.floor(inst.sickness * 100))
    end
    if inst.infested > 0 then
        status[#status + 1] = string.format(tr.infested, inst.infested or 0, inst.infested_max or 0)
    end
    descriptions[#descriptions + 1] = { name = "perennialcrop_status", priority = 0,
        description = table.concat(status, ",") }

    return unpack(descriptions)
end

return { Describe = Describe }
