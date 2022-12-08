local function GetTranslation(tr, context)
    local locale = context and context.etc and context.etc.locale
    -- print("Getting locale", locale)
    if not locale then
        return tr.base
    end
    return tr[locale] or tr.base
end

local function fill(tr_locale, tr_base)
    -- print("input:", dump(tr_locale), dump(tr_base))
    local base_type = type(tr_base)
    if base_type == "table" then
        local gen = {}
        for key, value in pairs(tr_base) do
            gen[key] = fill(tr_locale and tr_locale[key], value)
        end
        setmetatable(gen, (tr_locale and getmetatable(tr_locale)) or getmetatable(tr_base))
        -- print("result:", dump(gen))
        return gen
    else
        -- print("result:", dump(tr_locale or tr_base))
        return tr_locale or tr_base
    end
end

local function FillTranslation(tr)
    if not tr.base then
        local ret = {
            base = tr,
        }
    end
    for key, value in pairs(tr) do
        if key ~= "base" then
            -- print(key, dump(value))
            tr[key] = fill(value, tr.base)
        end
    end
    return tr
end

return {
    F = FillTranslation,
    Fill = FillTranslation,
    T = GetTranslation,
    GetTranslation = GetTranslation
}
