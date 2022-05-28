local tr = {
    description = "仍需 <icon=%s> %d 次",
    actions = {
        HAMMER = "hammer",
        CHOP = "axe",
        MINE = "pickaxe",
        DIG = "shovel",
    }
}

local function Describe(inst, context)
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
