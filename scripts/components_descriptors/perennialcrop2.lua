local tr = {
    paused = "暂停生长",
    next_stage = "%s后进入下一阶段",

    pollinated = "已授粉 %d 次",
    infested = "被骚扰 %d 次",
}

local function Describe(inst, context)
    local descriptions = {}
    if inst.timedata then
        if inst.timedata.paused or inst.timedata.mult == nil then
            descriptions[#descriptions + 1] = { name = "grow_time", priority = 0, description = tr.paused }
        elseif inst.timedata.start and inst.timedata.all then
            local alltime = inst.timedata.all * inst.timedata.mult
            local pass = GetTime() - inst.timedata.start
            local description = string.format(tr.next_stage, context.time:SimpleProcess(alltime - pass))
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
