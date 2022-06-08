GLOBAL.setmetatable(env, {
    __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end
})

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

    rawset(GLOBAL.Insight.prefab_descriptors, name, res)
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

    rawset(GLOBAL.Insight.descriptors, name, res)
end

print("Insight enabled: ", KnownModIndex:IsModEnabled("workshop-2189004162"))

if KnownModIndex:IsModEnabled("workshop-2189004162") then
    print("Add prefab descriptors")
    local prefabs = {
        "siving_ctlwater",
        "siving_ctldirt",
        "siving_turn",
        "siving_thetree",

        "tourmalinecore",
        "moondungeon",
        "web_hump" }
    for index, value in pairs(prefabs) do SetPrefabDescriptor(value) end

    print("Add components descriptors")
    SetComponentsDescriptor("perennialcrop")
    SetComponentsDescriptor("perennialcrop2")
    SetComponentsDescriptor("fishhomingbait")

    rawset(GLOBAL.Insight.prefab_descriptors, "icire_rock", GLOBAL.Insight.prefab_descriptors["heatrock"])
end
