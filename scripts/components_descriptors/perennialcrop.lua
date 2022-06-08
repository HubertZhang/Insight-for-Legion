local tr = {
    paused = "暂停生长",
    next_stage = "%s后进入下一阶段",

    nutrient = "养分: [<color=NATURE>%d<sub>催</sub></color>, <color=CAMO>%d<sub>堆</sub></color>, <color=INEDIBLE>%d<sub>粪</sub></color>]",
    moisture = "<color=WET>水分</color>: <color=WET>%d</color>  <color=MONSTER>疾病</color>: <color=MONSTER>%d%%</color>",
    pollinated = "<color=NATURE>对话%d次</color> <color=LIGHT_PINK>授粉%d次</color>",
    infested = "<color=#dd5555>侵害 %d/%d 次</color>",
}

local function Describe(inst, context)
    local descriptions = {}
    descriptions[#descriptions + 1] = {
        name = "perennialcrop_status",
        priority = 20,
        description = string.format(tr.moisture, inst.moisture, math.floor(inst.sickness * 100))
    }
    descriptions[#descriptions + 1] = {
        name = "perennialcrop_status",
        priority = 10,
        description = string.format(tr.nutrient, inst.nutrientgrow, inst.nutrientsick, inst.nutrient)
    }

    if inst.timedata then
        if inst.timedata.paused == nil then
            descriptions[#descriptions + 1] = { name = "perennialcrop_status", priority = 100, description = tr.paused }
        elseif inst.timedata.start and inst.timedata.all then
            local alltime = inst.timedata.all
            local pass = GetTime() - inst.timedata.start
            local description = string.format(tr.next_stage, context.time:SimpleProcess(alltime - pass))
            descriptions[#descriptions + 1] = { name = "perennialcrop_status", priority = 100, description = description }
        end
    end

    local status = {}
    status[#status + 1] = string.format(tr.pollinated, inst.num_tended or 0, inst.pollinated or 0)
    if inst.infested > 0 then
        status[#status + 1] = string.format(tr.infested, inst.infested or 0, inst.infested_max or 0)
    end
    descriptions[#descriptions + 1] = { name = "perennialcrop_status", priority = 0, description = table.concat(status, " ") }

    return unpack(descriptions)
end

return { Describe = Describe }
