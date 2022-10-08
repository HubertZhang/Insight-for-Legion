local tr = {
    color = "#0FB484",
    description = "生命值: %d / 500",
    range_description = "<color=#0FB484>吸取范围内的生命以补充生命值</color>"
}

local function Describe(inst, context)
    local description = string.format(tr.description, inst.countHealth)
    return { priority = 0, name = "siving_thetree", description = description },
        {
            name = "insight_ranged",
            priority = 0,
            description = tr.range_description,
            range = 25,
            color = tr.color,
            attach_player = false
        }

end

return { Describe = Describe }
