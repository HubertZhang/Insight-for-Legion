GLOBAL.setmetatable(env, {
    __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end
})

local _G = GLOBAL

local function SetPrefabDescriptor(name, module)
    module = module or name
    local res = require("prefab_descriptors/" .. module)
    assert(res.Describe == nil or type(res.Describe) == "function",
        string.format(
            "[Insight-Legion]: attempt to return '%s' as a complex prefab descriptor with Describe as '%s'",
            name, tostring(res.Describe)))

    if getmetatable(res) == nil then
        res.name = res.name or name
        setmetatable(res, {})
    end

    rawset(_G.Insight.prefab_descriptors, name, res)
end

local function SetComponentsDescriptor(name, module)
    module = module or name
    local res = require("components_descriptors/" .. module)
    assert(res.Describe == nil or type(res.Describe) == "function",
        string.format(
            "[Insight-Legion]: attempt to return '%s' as a complex components descriptor with Describe as '%s'",
            name, tostring(res.Describe)))

    if getmetatable(res) == nil then
        res.name = res.name or name
        setmetatable(res, {})
    end

    rawset(_G.Insight.descriptors, name, res)
end

local function AddDescriptors()
    print("[Insight-Legion]: Insight enabled: ", KnownModIndex:IsModEnabled("workshop-2189004162"))
    if not KnownModIndex:IsModEnabled("workshop-2189004162") then return end
    print("[Insight-Legion]: Legion enabled: ", KnownModIndex:IsModEnabled("workshop-1392778117"))
    if not KnownModIndex:IsModEnabled("workshop-1392778117") then return end

    print("[Insight-Legion]: Add prefab descriptors")
    local prefabs = {
        "siving_turn",
        "siving_thetree",

        "siving_boss_flower",

        "tourmalinecore",
        "moondungeon",
        "web_hump",
        "monstrain_wizen",
    }
    for index, value in pairs(prefabs) do SetPrefabDescriptor(value) end

    SetPrefabDescriptor("siving_foenix", "siving_foenix")
    SetPrefabDescriptor("siving_moenix", "siving_foenix")

    SetPrefabDescriptor("siving_mask", "siving_mask")
    SetPrefabDescriptor("siving_mask_gold", "siving_mask")

    print("[Insight-Legion]: Add components descriptors")
    SetComponentsDescriptor("perennialcrop")
    SetComponentsDescriptor("perennialcrop2")
    SetComponentsDescriptor("fishhomingbait")
    SetComponentsDescriptor("botanycontroller")
end

AddPrefabPostInit("siving_thetree", function(inst)
    print("[Insight-Legion]: Add range indicator for siving tree1")
    inst.drink_indicator = SpawnPrefab("siving_range_indicator")
    inst.drink_indicator:Attach(inst)
    inst.drink_indicator:SetRadius(25 / 4)
    inst.drink_indicator:SetColour({ 0x0F / 256, 0xB4 / 256, 0x84 / 256, 1 })
    inst.drink_indicator:SetVisible(true)
end)

PrefabFiles = { "siving_range_indicator" }

AddSimPostInit(AddDescriptors)
