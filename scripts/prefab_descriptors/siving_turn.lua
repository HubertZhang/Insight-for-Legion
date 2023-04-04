local L = require("insight_plugin_lang")

-- #import scripts/legendoffall_legion.lua
local mapseeds = {
    carrot_oversized = {
        swap = { build = "farm_plant_carrot", file = "swap_body", symboltype = "3" },
        fruit = "seeds_carrot_l"
    },
    corn_oversized = {
        swap = { build = "farm_plant_corn_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_corn_l"
    },
    pumpkin_oversized = {
        swap = { build = "farm_plant_pumpkin", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pumpkin_l"
    },
    eggplant_oversized = {
        swap = { build = "farm_plant_eggplant_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_eggplant_l"
    },
    durian_oversized = {
        swap = { build = "farm_plant_durian_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_durian_l"
    },
    pomegranate_oversized = {
        swap = { build = "farm_plant_pomegranate_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pomegranate_l"
    },
    dragonfruit_oversized = {
        swap = { build = "farm_plant_dragonfruit_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_dragonfruit_l"
    },
    watermelon_oversized = {
        swap = { build = "farm_plant_watermelon_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_watermelon_l"
    },
    pineananas_oversized = {
        swap = { build = "farm_plant_pineananas", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pineananas_l"
    },
    onion_oversized = {
        swap = { build = "farm_plant_onion_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_onion_l"
    },
    pepper_oversized = {
        swap = { build = "farm_plant_pepper", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pepper_l"
    },
    potato_oversized = {
        swap = { build = "farm_plant_potato", file = "swap_body", symboltype = "3" },
        fruit = "seeds_potato_l"
    },
    garlic_oversized = {
        swap = { build = "farm_plant_garlic", file = "swap_body", symboltype = "3" },
        fruit = "seeds_garlic_l"
    },
    tomato_oversized = {
        swap = { build = "farm_plant_tomato", file = "swap_body", symboltype = "3" },
        fruit = "seeds_tomato_l"
    },
    asparagus_oversized = {
        swap = { build = "farm_plant_asparagus", file = "swap_body", symboltype = "3" },
        fruit = "seeds_asparagus_l"
    },
    mandrake = {
        swap = { build = "siving_turn", file = "swap_mandrake", symboltype = "1" },
        fruit = "seeds_mandrake_l",
        time = 20 * TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 1,
        fruitnum_max = 1,
        genekey = "mandrakesoup"
    },
    gourd_oversized = {
        swap = { build = "farm_plant_gourd", file = "swap_body", symboltype = "3" },
        fruit = "seeds_gourd_l"
    },
    squamousfruit = {
        swap = { build = "squamousfruit", file = "swap_turn", symboltype = "1" },
        fruit = "dug_monstrain",
        time = 2 * TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 1,
        fruitnum_max = 1,
        genekey = "raindonate"
    },
    cactus_flower = {
        swap = { build = "crop_legion_cactus", file = "swap_turn", symboltype = "1" },
        fruit = "seeds_cactus_meat_l",
        time = 2 * TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 1,
        fruitnum_max = 1,
        genekey = "tissue_l_cactus"
    },
    lureplantbulb = {
        swap = { build = "crop_legion_lureplant", file = "swap_turn", symboltype = "1" },
        fruit = "seeds_plantmeat_l",
        time = 2 * TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 1,
        fruitnum_max = 1,
        genekey = "tissue_l_lureplant"
    }
}
-- #endimport

local TRANS_DATA_LEGION = _G.TRANS_DATA_LEGION or mapseeds


local tr = {
    base = {
        single_description = "正在转化 <prefab=%s>，<color=#0FB484>%s</color> 后转化完成",
        multiple_description = "正在转化 <color=#0FB484>%d</color> 个 <prefab=%s>" .. "\n" ..
            "<color=#0FB484>%s</color> 后转化完成，共需要 <color=#0FB484>%s</color>",
        energy_description = "剩余能量 <color=#0FB484>%s</color>",
        pool_prefix = "已放入标本：",
        held_charge = "手中 %d 个 <color=#0FB484><prefab=%s></color> 可补充 %s 时长",
        seed_not_match = "正在转化 <prefab=%s>，将替换为手中 <prefab=%s>",
        seed_new = "将转化手中 <prefab=%s>，耗时 %s"
    },
    en = {
        turn_description = "Transforming <prefab=%s>, next one complete in %s",
        single_description = "Transforming <prefab=%s>, next one complete in <color=#0FB484>%s</color>",
        multiple_description = "Transforming <color=#0FB484>%d</color> <prefab=%s>" .. "\n" ..
            "next one complete in <color=#0FB484>%s</color>, total: <color=#0FB484>%s</color>",
        energy_description = "Energy <color=#0FB484>%s</color>",
        pool_prefix = "Tissue Collected: ",
        held_charge = "Held %d <color=#0FB484><prefab=%s></color> will refuel %s",
        seed_not_match = "Transforming <prefab=%s> will be replaced by held <prefab=%s>",
        seed_new = "Will transform <prefab=%s> in %s"
    }
}

local function describeItem(cpt, item, context)
    local tr = L.T(tr, context)
    local data = TRANS_DATA_LEGION[item.prefab]
    if not data then
        return
    end
    if cpt.seed and item.prefab ~= cpt.seed then
        local description = string.format(tr.seed_not_match, cpt.seed or "unknown", item.prefab or "unknown")
        return { name = "siving_turn_held", priority = 15, description = description }
    else
        local description = string.format(tr.seed_new, item.prefab,
            context.time:SimpleProcess(data.time or TUNING.TOTAL_DAY_TIME))
        return { name = "siving_turn_held", priority = 15, description = description }
    end
end

local function Describe(inst, context)
    local tr = L.T(tr, context)
    local cpt = inst.components and inst.components.genetrans
    local descriptions = {}
    if cpt then
        if cpt.timedata and cpt.timedata.all and cpt.timedata.pass then
            if cpt.seednum and cpt.seednum > 1 then
                local single_time = cpt.timedata.all or 0
                local description = string.format(tr.multiple_description,
                    cpt.seednum or 1,
                    cpt.seed or "unknown",
                    context.time:SimpleProcess(cpt.timedata.all - cpt.timedata.pass),
                    context.time:SimpleProcess(cpt.timedata.all - cpt.timedata.pass + single_time * (cpt.seednum - 1))
                )
                descriptions[#descriptions + 1] = { name = "siving_turn_task", priority = 10, description = description }
            else
                local description = string.format(tr.single_description,
                    cpt.seed or "unknown",
                    context.time:SimpleProcess(cpt.timedata.all - cpt.timedata.pass)
                )
                descriptions[#descriptions + 1] = { name = "siving_turn_task", priority = 10, description = description }
            end
        end
        if cpt.genepool then
            local gene = {}
            for key, value in pairs(cpt.genepool) do
                gene[#gene + 1] = "<prefab=" .. key .. ">"
            end
            local description = table.concat(gene, " ")
            descriptions[#descriptions + 1] = {
                name = "siving_turn_gene",
                priority = 0,
                description = tr.pool_prefix .. description
            }
        end
        if cpt.energytime then
            local description = string.format(tr.energy_description, context.time:SimpleProcess(cpt.energytime))
            descriptions[#descriptions + 1] = {
                name = "siving_turn_energy",
                priority = 5,
                description = description
            }
        end
        local held_item = context.player.components.inventory and
            context.player.components.inventory:GetActiveItem()
        if held_item then
            if held_item.prefab == "siving_rock" then
                if cpt.energytime < cpt.energytime_max then
                    local needtime = cpt.energytime_max - cpt.energytime
                    local itemtime = 0

                    if held_item.components and held_item.components.stackable ~= nil then
                        local num = held_item.components.stackable:StackSize() or 1
                        local numused = 0
                        for i = 1, num, 1 do
                            numused = i
                            itemtime = itemtime + TUNING.TOTAL_DAY_TIME
                            if itemtime >= needtime then
                                break
                            end
                        end

                        local description = string.format(
                            tr.held_charge,
                            numused,
                            held_item.prefab,
                            context.time:SimpleProcess(itemtime)
                        )
                        descriptions[#descriptions + 1] = {
                            name = "siving_turn_charge",
                            priority = 0,
                            description = description
                        }
                    end
                end
            else
                local d = describeItem(cpt, held_item, context)
                if d then
                    descriptions[#descriptions + 1] = d
                end
            end
        end
        local carried_item = context.player.components.inventory and
            context.player.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        if carried_item then
            local d = describeItem(cpt, carried_item, context)
            if d then
                descriptions[#descriptions + 1] = d
            end
        end
    end

    return unpack(descriptions)
end

return { Describe = Describe }
