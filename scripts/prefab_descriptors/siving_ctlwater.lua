local ctlFuledItems = {
    ice = { moisture = 100, nutrients = nil },
    icehat = { moisture = 1000, nutrients = { 8, nil, 8 } },
    wintercooking_mulleddrink = { moisture = 100, nutrients = { 2, 2, 8 } },
    waterballoon = { moisture = 400, nutrients = { nil, 2, nil } },
    oceanfish_medium_8_inv = { moisture = 200, nutrients = { 16, nil, nil } }, --冰鲷鱼
    watermelonicle = { moisture = 200, nutrients = { 8, 8, 16 } },
    icecream = { moisture = 200, nutrients = { 24, 24, 24 } },
    cutted_rosebush = { moisture = nil, nutrients = { 5, 5, 8 } },
    cutted_lilybush = { moisture = nil, nutrients = { 5, 5, 8 } },
    cutted_orchidbush = { moisture = nil, nutrients = { 5, 5, 8 } },
    sachet = { moisture = nil, nutrients = { 8, 8, 8 } },
    rosorns = { moisture = nil, nutrients = { 12, 12, 48 } },
    lileaves = { moisture = nil, nutrients = { 12, 48, 12 } },
    orchitwigs = { moisture = nil, nutrients = { 48, 12, 12 } },
}

local tr = {
    description = "<color=#95BFF2>水量</color>:<color=#95BFF2>%d</color> / <color=#95BFF2>1600</color>",
    held_add_moisture_stack = "手中 %d 个 <color=WET><prefab=%s></color> 可补充 %d 水量",
    held_add_moisture_use = "手中 <color=WET><prefab=%s></color> %d次 使用 可补充 %d 水量",
    held_add_moisture = "手中 <color=WET><prefab=%s></color> 可补充 %d 水量",
}

local function Describe(inst, context)
    local botanycontroller = inst.components.botanycontroller or {}
    local moisture = botanycontroller.moisture or 0
    local description = string.format(tr.description, moisture)
    local descriptors = { { priority = 0, name = "water", description = description }, {
        name = "insight_ranged",
        priority = 0,
        description = nil,
        range = 21,
        color = "#95BFF2",
        attach_player = false
    } }
    local held_item = context.player.components.inventory and
        context.player.components.inventory:GetActiveItem()
    if held_item then
        local add_moisture = nil
        local stackable = false
        local useable = false
        local count = 0
        if ctlFuledItems[held_item.prefab] and ctlFuledItems[held_item.prefab].moisture then
            add_moisture = ctlFuledItems[held_item.prefab].moisture
        elseif held_item.components.wateryprotection then
            local waterypro = held_item.components.wateryprotection
            if waterypro.addwetness == nil or waterypro.addwetness == 0 then
                add_moisture = 20
            else
                add_moisture = waterypro.addwetness
            end
            if held_item.components.finiteuses == nil then
                add_moisture = add_moisture * 10
            end
        elseif held_item.siv_ctl_fueled then
            add_moisture = held_item.siv_ctl_fueled.moisture
        end
        if add_moisture ~= nil then
            if held_item.components.stackable then
                stackable = true
                count = held_item.components.stackable:StackSize()
            elseif held_item.components.finiteuses then
                useable = true
                count = held_item.components.finiteuses:GetUses()
            else
                count = 1
            end
            add_moisture = add_moisture * count
            if stackable then
                descriptors[#descriptors + 1] = {
                    priority = 0,
                    name = "refuel",
                    description = string.format(
                        tr.held_add_moisture_stack, count, held_item.prefab, add_moisture
                    )
                }
            elseif useable then
                descriptors[#descriptors + 1] = {
                    priority = 0,
                    name = "refuel",
                    description = string.format(
                        tr.held_add_moisture_use, held_item.prefab, count, add_moisture
                    )
                }
            else
                descriptors[#descriptors + 1] = {
                    priority = 0,
                    name = "refuel",
                    description = string.format(
                        tr.held_add_moisture, held_item.prefab, add_moisture
                    )
                }
            end
        end
    end
    return unpack(descriptors)
end

return { Describe = Describe }
