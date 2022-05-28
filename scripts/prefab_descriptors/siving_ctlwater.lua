local tr = {
    description = "<color=#95BFF2>水量</color>:<color=#95BFF2>%d</color> / <color=#95BFF2>1600</color>",
    can_add_moisture = "可使用 %s 填充水量",
    held_add_moisture_stack = "手中 %d 个 <color=WET><prefab=%s></color> 可补充 %d 水量",
    held_add_moisture = "手中 <color=WET><prefab=%s></color> 可补充 %d 水量",
}

local ctlFuledItems = {
    ice = { moisture = 100, nutrients = nil },
    icehat = { moisture = 1000, nutrients = { 8, nil, 8 } },
    wintercooking_mulleddrink = { moisture = 100, nutrients = { 2, 2, 8 } },
    waterballoon = { moisture = 400, nutrients = { nil, 2, nil } },
    oceanfish_medium_8_inv = { moisture = 200, nutrients = { 16, nil, nil } }, --冰鲷鱼
    watermelonicle = { moisture = 200, nutrients = { 8, 8, 16 } },
    icecream = { moisture = 200, nutrients = { 24, 24, 24 } },
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
        if ctlFuledItems[held_item.prefab] ~= nil then
            descriptors[#descriptors + 1] = { priority = 0, name = "refuel", description = string.format(
                tr.held_add_moisture_stack,
                1, held_item.prefab,
                ctlFuledItems[held_item.prefab].moisture) }
        elseif held_item.components.wateryprotection then
            local waterypro = held_item.components.wateryprotection
            local value_m = nil
            if waterypro ~= nil then
                if waterypro.addwetness == nil or waterypro.addwetness == 0 then
                    value_m = 20
                else
                    value_m = waterypro.addwetness
                end
                if held_item.components.finiteuses ~= nil then
                    value_m = value_m * held_item.components.finiteuses:GetUses() --普通水壶是+1000
                else
                    value_m = value_m * 10
                end
            end
            descriptors[#descriptors + 1] = { priority = 0, name = "refuel", description = string.format(
                tr.held_add_moisture,
                held_item.prefab,
                value_m) }
        end
    end
    return unpack(descriptors)
end

return { Describe = Describe }
