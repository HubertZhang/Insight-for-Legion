local tr = {
    description = "生命值: %d / 800\n<color=#0FB484>吸取范围内的生命，掉落子圭岩或为玄鸟补充生命值</color>"
}

local function Describe(inst, context)
    local description = string.format(tr.description, inst.countHealth)
    return { priority = 0, name = "siving_thetree", description = description }
end

return { Describe = Describe }
