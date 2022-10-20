local tr = {
    description = "%s 后为玄鸟恢复 <icon=health> <color=HEALTH>%d</color> ",
}

local function Describe(inst, context)
    if inst._task_health and inst._task_health:NextTime() then
        local description = string.format(
            tr.description,
            context.time:SimpleProcess(inst._task_health:NextTime() - GetTime()),
            inst.components.health.currenthealth
        )
        return {
            name = "siving_boss_flower",
            priority = 0,
            description = description
        }
    end
end

return { Describe = Describe }
