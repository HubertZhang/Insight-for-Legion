local assets = {
    --Asset("ANIM", "anim/firefighter_placement.zip") -- bank: firefighter_placement, build: firefighter_placement
    --Asset("ANIM", "anim/range_old.zip") -- bank: firefighter_placement, build: range_old
    Asset("ANIM", "anim/range_tweak.zip") -- bank: bank_rt, build: range_tweak
}

local PLACER_SCALE = 1.55 -- from firesuppressor
local ratio = 1 / PLACER_SCALE -- "s" in placer_postinit_fn in firesuppressor

--- Changes the radius of the indicator.
-- @param inst The indicator
-- @number radius The radius the indicator will be set to. Interpreted as number of tiles.
local function SetRadius(inst, radius)
    local parent = inst.entity:GetParent()
    if not parent then
        print("attempt to call SetRadius with no entity parent")
        return
    end
    -- radius should be # of tiles

    local scale = math.sqrt(ratio * radius) -- the math.sqrt is a lucky guess. i was thinking along the lines of how SOMETHING (wortox soul detector but also the firefighter radius) needed to be reduced
    -- and i guess i thought of how it was a square/circle thing. nice!


    local a, b, c = parent.Transform:GetScale()

    inst.Transform:SetScale(scale / a, scale / b, scale / c)

end

--- Changes the colour of the indicator.
-- @param inst The indicator
-- @tparam ?Color|table|{r,g,b,a} The colour the indicator will be set to. Interpreted as number of tiles.
local function SetColour(inst, ...)
    -- yeah i don't know how SetAddColour and SetMultColour work, i just know SetMultColour is what i've used before
    if type(...) == "table" then
        inst.AnimState:SetMultColour(unpack(...))
    elseif select("#", ...) == 4 then
        inst.AnimState:SetMultColour(...)
    else
        print("SetColour not done properly: " .. tostring(inst) .. " | ")
    end
end

local function SetVisible(inst, bool)
    inst.is_visible = bool
    if inst.net_visible then
        inst.net_visible:set(bool)
    end
end

local function Attach(inst, to)
    -- setting a player's parent to itself is an immediate crash with no error
    inst.attached_to = to
    inst.entity:SetParent(to.entity)

    --[[
	to:ListenForEvent("enterlimbo", function()

	end)

	to:ListenForEvent("exitlimbo", function()
		
	end)
	--]]
end

local function base_fn()
    local inst = CreateEntity()


    inst.entity:SetCanSleep(false) -- parent sleep takes precedence
    inst.persists = false -- fine

    -- adds
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    -- tags
    --inst:AddTag("FX") -- apparently DAR adds this, idk why. overrides NOCLICK
    --inst:AddTag("DECOR")
    inst:AddTag("NOBLOCK") -- this mod [HM]Onikiri/鬼切 1.0.7 https://steamcommunity.com/sharedfiles/filedetails/?id=2241060736 was tampering with my indicators. they add "NOBLOCK", and replace all the functions in "inst" with a NOP.
    -- was blocking placement next to the body (like when wormwood would go to plant a seed, the blocking of the indicator would stop him from doing so even though it looked valid)
    inst:AddTag("NOCLICK")
    inst:AddTag("CLASSIFIED")

    -- transform
    --inst.Transform:SetScale(0, 0, 0)

    -- animations
    inst.AnimState:SetBank("bank_rt")
    inst.AnimState:SetBuild("range_tweak")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    --inst.AnimState:SetLightOverride(1) -- ignores darkness
    inst.AnimState:SetSortOrder(3)
    --inst.AnimState:SetMultColour(0, 0, 0, 1)
    --inst.AnimState:SetAddColour(1, 0, 0, 1)
    --inst.AnimState:SetMultColour(1, 1, 1, 1)
    --inst.AnimState:SetAddColour(0, 0, 0, 1)
    --inst.AnimState:SetMultColour(.63, .16, .13, 1)

    inst.SetRadius = SetRadius
    inst.SetColour = SetColour
    inst.SetVisible = SetVisible
    inst.Attach = Attach

    inst:SetVisible(false)

    return inst
end

return Prefab("siving_range_indicator", base_fn, assets)
