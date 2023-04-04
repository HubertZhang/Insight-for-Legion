local L = require("insight_plugin_lang")

-- #import scripts/prefabs/siving_related.lua
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
-- #endimport

local tr = L.F {
    base = {
        nutrients_max_suffix = " / %d",
        moisture_max_suffix = " / %d",
        -- nutrients_description = "养分: [<color=NATURE>%d<sub>催</sub></color>, <color=CAMO>%d<sub>堆</sub></color>, <color=INEDIBLE>%d<sub>粪</sub></color>] / %d",
        -- moisture_description = "<color=#95BFF2>水量</color>:<color=#95BFF2>%d</color> / <color=#95BFF2>%d</color>",
        held_add_nutrients_middle = " 可补充",
        held_add_nutrients_stack = "手中 %d 个 <color=NATURE><prefab=%s></color>",
        held_add_nutrients_use = "手中 <color=NATURE><prefab=%s></color> %d次 使用",
        held_add_nutrients = "手中 <color=NATURE><prefab=%s></color>",
        held_add_moisture_suffix = " 可补充 %d 水量",
        held_add_moisture_stack = "手中 %d 个 <color=WET><prefab=%s></color>",
        held_add_moisture_use = "手中 <color=WET><prefab=%s></color> %d次 使用",
        held_add_moisture = "手中 <color=WET><prefab=%s></color>",
    },
    en = {
        held_add_nutrients_middle = " could restore ",
        held_add_nutrients_stack = "Held %d <color=NATURE><prefab=%s></color>",
        held_add_nutrients_use = "Held <color=NATURE><prefab=%s></color>'s %d uses",
        held_add_nutrients = "Held <color=NATURE><prefab=%s></color>",
        held_add_moisture_suffix = " could restore %d moisture",
        held_add_moisture_stack = "Held %d <color=WET><prefab=%s></color>",
        held_add_moisture_use = "Held <color=WET><prefab=%s></color>'s %d uses",
        held_add_moisture = "Held <color=WET><prefab=%s></color>",
    }
}

local function CalUse(single, count, current, limitation)
    if not single or single == 0 then
        return 0
    end
    local diff = (limitation or 0) - (current or 0)
    local max_use = math.ceil(diff / single)
    return math.min(max_use, count)
end

local function CalNutrientUse(single, count, current, limitation)
    if not single then
        return { 0 }
    end
    local ret = {}
    for index, value in ipairs(single) do
        ret[index] = CalUse(single[index], count, current[index], limitation)
    end
    return ret
end

local function Describe(botanycontroller, context)
    local tr = L.T(tr, context)
    local descriptors = {}
    local controller_type = botanycontroller.type or 0
    local nutrients = botanycontroller.nutrients or {}
    local moisture = botanycontroller.moisture or 0
    local can_control_nutrients = controller_type == 2 or controller_type == 3
    local can_control_moisture = controller_type == 1 or controller_type == 3


    -- Status Description
    local parts = {}
    if can_control_nutrients then
        parts[#parts + 1] = string.format(context.lstr.fertilizer.nutrient_value .. tr.nutrients_max_suffix,
            nutrients[1], nutrients[2], nutrients[3],
            botanycontroller.nutrient_max)
    end
    if can_control_moisture then
        parts[#parts + 1] = string.format(context.lstr.farmsoildrinker.soil_only .. tr.moisture_max_suffix,
            tostring(math.floor(moisture)),
            botanycontroller.moisture_max)
    end
    descriptors[#descriptors + 1] = {
        priority = 0,
        name = "botanycontroller",
        description = table.concat(parts, '\n')
    }

    local held_item = context.player.components.inventory and
        context.player.components.inventory:GetActiveItem()
    if held_item then
        local add_nutrients = nil
        local add_moisture = nil

        local stackable = false
        local useable = false
        local count = 0
        if ctlFuledItems[held_item.prefab] and ctlFuledItems[held_item.prefab].nutrients then
            add_moisture = ctlFuledItems[held_item.prefab].moisture
            add_nutrients = ctlFuledItems[held_item.prefab].nutrients
        elseif held_item.siv_ctl_fueled then
            add_nutrients = held_item.siv_ctl_fueled.nutrients
            add_moisture = held_item.siv_ctl_fueled.moisture
        else
            if held_item.components.fertilizer and held_item.components.fertilizer.nutrients then
                add_nutrients = held_item.components.fertilizer.nutrients
            end
            if held_item.components.wateryprotection then
                local waterypro = held_item.components.wateryprotection
                if waterypro.addwetness == nil or waterypro.addwetness == 0 then
                    add_moisture = 20
                else
                    add_moisture = waterypro.addwetness
                end
                if held_item.components.finiteuses == nil then
                    add_moisture = add_moisture * 10
                end
            end
        end

        if held_item.components.stackable then
            stackable = true
            count = held_item.components.stackable:StackSize()
            count = math.max(
                unpack(
                    CalNutrientUse(add_nutrients, count, botanycontroller.nutrients, botanycontroller.nutrient_max)
                ),
                CalUse(add_moisture, count, botanycontroller.moisture, botanycontroller.moisture_max)
            )
        elseif held_item.components.finiteuses then
            useable = true
            count = held_item.components.finiteuses:GetUses()
            count = math.max(
                unpack(
                    CalNutrientUse(add_nutrients, count, botanycontroller.nutrients, botanycontroller.nutrient_max)
                ),
                count
            )
        else
            count = 1
        end

        if can_control_nutrients and add_nutrients ~= nil then
            local total_nutrients = { 0, 0, 0 }
            for i = 1, 3 do
                total_nutrients[i] = math.floor(count * (add_nutrients[i] or 0) * 1.3)
            end
            local tempPrefix = ""
            if stackable then
                tempPrefix = string.format(tr.held_add_nutrients_stack, count, held_item.prefab)
            elseif useable then
                tempPrefix = string.format(tr.held_add_nutrients_use, held_item.prefab, count)
            else
                tempPrefix = string.format(tr.held_add_nutrients, held_item.prefab)
            end
            descriptors[#descriptors + 1] = {
                priority = 0,
                name = "add_nutrients",
                description = tempPrefix .. tr.held_add_nutrients_middle ..
                    string.format(context.lstr.farmsoildrinker_nutrients.soil_only, unpack(total_nutrients))
            }
        end

        if can_control_moisture and add_moisture ~= nil then
            local total_moisture = add_moisture * count
            local tempPrefix = ""
            if stackable then
                tempPrefix = string.format(tr.held_add_moisture_stack, count, held_item.prefab)
            elseif useable then
                tempPrefix = string.format(tr.held_add_moisture_use, held_item.prefab, count, total_moisture)
            else
                tempPrefix = string.format(tr.held_add_moisture, held_item.prefab, total_moisture)
            end
            descriptors[#descriptors + 1] = {
                priority = 0,
                name = "add_moisture",
                description = tempPrefix .. string.format(tr.held_add_moisture_suffix, total_moisture)
            }
        end
    end
    return unpack(descriptors)
end

return { Describe = Describe }
