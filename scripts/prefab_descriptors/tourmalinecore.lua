local tr = {
    description = "%s 后电击",
}

local function Describe(inst, context)
    if inst.updatetask then
        local description = string.format(tr.description,
            context.time:SimpleProcess(inst.updatetask:NextTime() - GetTime()))
        return { name = "tourmalinecore", priority = 0, description = description }
    end
end

return { Describe = Describe }
