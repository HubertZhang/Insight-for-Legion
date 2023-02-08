local L = require("insight_plugin_lang")

local times_revolved_pro = CONFIGS_LEGION.REVOLVEDUPDATETIMES or 20
local times_revolved = math.floor(times_revolved_pro / 2) + 1

local tr = L.F {
        base = {
            description = "已嵌入 %d 个<color=#E4CD41><prefab=yellowgem></color>",
            alt_description = "已嵌入 %d / %d 个<color=#E4CD41><prefab=yellowgem></color>\n发光，低温时恢复体温\n黄宝石可减少恢复 CD、增加发光范围",
        },
        en = {
            description = "%d <color=#E4CD41><prefab=yellowgem></color> embedded",
            alt_description = "%d / %d <color=#E4CD41><prefab=yellowgem></color> embedded\nProvide light, prevent frozen\nEmbedded <color=#E4CD41><prefab=yellowgem></color> can increase light range and reduce CD",
        }
    }



local function Describe(inst, context)
    local tr = L.T(tr, context)
    if not inst.components.upgradeable then
        return
    end
    local stagenow = inst.components.upgradeable:GetStage() - 1
    local description = string.format(tr.description, stagenow)

    local alt_description
    if inst.prefab == "revolvedmoonlight_pro" then
        alt_description = string.format(tr.alt_description, stagenow, times_revolved_pro)
    else
        alt_description = string.format(tr.alt_description, stagenow, times_revolved)
    end

    return { priority = 0, description = description, alt_description = alt_description }
end

return { Describe = Describe }
