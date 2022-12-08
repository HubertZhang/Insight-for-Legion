local L = require("insight_plugin_lang")

local tr = {
    base = {
        turn_description = "%s 后转化完成",
        energy_description = "剩余能量 %d 秒",
        held_charge = "手中 %d 个 <color=#0FB484><prefab=%s></color> 可补充 %d 秒能量",
    },
    en = {
        turn_description = "Transformation complete in %s",
        energy_description = "<color=#95BFF2>Energy</color>: %d second(s)",
        held_charge = "Held %d <color=#0FB484><prefab=%s></color> will refuel %d second(s)",
    }
}

local function Describe(inst, context)
    local tr = L.T(tr, context)
    local cpt = inst.components and inst.components.genetrans
    local descriptions = {}
    if cpt then
        if cpt.timedata and cpt.timedata.all and cpt.timedata.pass then
            local description = string.format(tr.turn_description,
                context.time:SimpleProcess(cpt.timedata.all - cpt.timedata.pass))
            descriptions[#descriptions + 1] = { name = "siving_turn_task", priority = 0, description = description }
        end
        if cpt.energytime then
            local description = string.format(tr.energy_description, cpt.energytime)
            descriptions[#descriptions + 1] = { name = "siving_turn_energy", priority = 0, description = description }
        end
        local held_item = context.player.components.inventory and
            context.player.components.inventory:GetActiveItem()
        if held_item and held_item.prefab == "siving_rock" then
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
                    local description = string.format(tr.energy_description, numused, held_item.prefab, itemtime)
                    descriptions[#descriptions + 1] = { name = "siving_turn_charge", priority = 0,
                        description = description }
                end
            end
        end
    end

    return unpack(descriptions)
end

return { Describe = Describe }
