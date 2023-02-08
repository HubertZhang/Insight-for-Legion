local L = require("insight_plugin_lang")

local times_hidden = CONFIGS_LEGION.HIDDENUPDATETIMES or 56
local step_hidden = math.floor(times_hidden / 14)

local tr = L.F {
        base = {
            description = "月圆可返鲜 %d 格物品",
            gem_stage = "已嵌入 %d 个<color=#37579C><prefab=bluegem></color>",
            gem_consume = "，每嵌入 " .. step_hidden .. " 颗 可增加一格"
        },
        en = {
            description = "Restore freshness for %d slots",
            gem_stage = "%d <color=#37579C><prefab=bluegem></color> embedded",
            gem_consume = ", one more slot every " .. step_hidden
        }
    }



local function Describe(inst, context)
    local tr = L.T(tr, context)
    if not inst.components.upgradeable then
        return
    end
    local stagenow = inst.components.upgradeable:GetStage() - 1
    local gem_stage = string.format(tr.gem_stage, stagenow)
    if stagenow > times_hidden then --在设置变换中，会出现当前等级大于最大等级的情况
        stagenow = times_hidden
    end
    stagenow = math.floor(stagenow / step_hidden) + 2 --默认2格
    local description = string.format(tr.description, stagenow)
    if stagenow < 16 then
        gem_stage = gem_stage .. tr.gem_consume
    end
    return { priority = 0, description = description .. "\n" .. gem_stage }
end

return { Describe = Describe }
