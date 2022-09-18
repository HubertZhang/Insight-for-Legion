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
        "siving_ctlwater",
        "siving_ctldirt",
        "siving_turn",
        "siving_thetree",

        "tourmalinecore",
        "moondungeon",
        "web_hump"
    }
    for index, value in pairs(prefabs) do SetPrefabDescriptor(value) end

    print("[Insight-Legion]: Add components descriptors")
    SetComponentsDescriptor("perennialcrop")
    SetComponentsDescriptor("perennialcrop2")
    SetComponentsDescriptor("fishhomingbait")

    rawset(_G.Insight.prefab_descriptors, "icire_rock", _G.Insight.prefab_descriptors["heatrock"])
end

AddSimPostInit(AddDescriptors)
