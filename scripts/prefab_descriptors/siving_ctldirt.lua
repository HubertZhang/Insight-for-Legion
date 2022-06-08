local ctlFuledItems = {
    ice = { moisture = 100, nutrients = nil },
    icehat = { moisture = 1000, nutrients = { 8, nil, 8 } },
    wintercooking_mulleddrink = { moisture = 100, nutrients = { 2, 2, 8 } },
    waterballoon = { moisture = 400, nutrients = { nil, 2, nil } },
    oceanfish_medium_8_inv = { moisture = 200, nutrients = { 16, nil, nil } }, --冰鲷鱼
    watermelonicle = { moisture = 200, nutrients = { 8, 8, 16 } },
    icecream = { moisture = 200, nutrients = { 24, 24, 24 } },
}

local tr = {
    description = "养分: [<color=NATURE>%d<sub>催</sub></color>, <color=CAMO>%d<sub>堆</sub></color>, <color=INEDIBLE>%d<sub>粪</sub></color>]",
    held_add_nutrients_stack = "手中 %d 个 <color=NATURE><prefab=%s></color> 可补充养分 [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]",
    held_add_nutrients_use = "手中 <color=NATURE><prefab=%s></color> %d次 使用 可补充养分 [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]",
    held_add_nutrients = "手中 <color=NATURE><prefab=%s></color> 可补充养分 [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]",
}

local function Describe(inst, context)
    local botanycontroller = inst.components.botanycontroller or {}
    local nutrients = botanycontroller.nutrients or {}
    local description = string.format(tr.description, nutrients[1], nutrients[2], nutrients[3])
    local descriptors = { { priority = 0, name = "nature", description = description }, {
        name = "insight_ranged",
        priority = 0,
        description = nil,
        range = 21,
        color = "#9BD554",
        attach_player = false
    } }
    local held_item = context.player.components.inventory and
        context.player.components.inventory:GetActiveItem()
    if held_item then
        local add_nutrients = nil
        local stackable = false
        local useable = false
        local count = 0
        if ctlFuledItems[held_item.prefab] and ctlFuledItems[held_item.prefab].nutrients then
            add_nutrients = ctlFuledItems[held_item.prefab].nutrients
            count = 1
        elseif held_item.components.fertilizer and held_item.components.fertilizer.nutrients then
            add_nutrients = held_item.components.fertilizer.nutrients

            if held_item.components.finiteuses then
                useable = true
                count = held_item.components.finiteuses:GetUses()
            end
            if held_item.components.stackable then
                stackable = true
                count = held_item.components.stackable:StackSize()
            end
        end
        if add_nutrients ~= nil then
            local total_nutrients = { 0, 0, 0 }
            for i = 1, 3 do
                total_nutrients[i] = math.floor(count * (add_nutrients[i] or 0) * 1.3)
            end
            if stackable then
                descriptors[#descriptors + 1] = {
                    priority = 0,
                    name = "refuel",
                    description = string.format(
                        tr.held_add_nutrients_stack, count, held_item.prefab, unpack(total_nutrients)
                    )
                }
            elseif useable then
                descriptors[#descriptors + 1] = {
                    priority = 0,
                    name = "refuel",
                    description = string.format(
                        tr.held_add_nutrients_use, held_item.prefab, count, unpack(total_nutrients)
                    )
                }
            else
                descriptors[#descriptors + 1] = {
                    priority = 0,
                    name = "refuel",
                    description = string.format(
                        tr.held_add_nutrients, held_item.prefab, unpack(total_nutrients)
                    )
                }
            end
        end
    end
    return unpack(descriptors)

end

return { Describe = Describe }
