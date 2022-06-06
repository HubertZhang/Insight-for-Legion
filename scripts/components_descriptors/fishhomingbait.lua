local tr = {
    times = "每%d秒召唤一条鱼，可召唤%d条鱼",
    special_prefix = "<color=NATURE>特殊鱼种</color>: ",
    special_sep = " ",
    normal_prefix = "<color=WET>普通鱼种</color>: ",
    normal_sep = " ",
}

local function GetPrey(self)
    local preys = { normal = nil, special = nil, allweight = nil }
    local chance_lit = 1
    local chance_low = 3
    local chance_med = 5
    local chance_high = 8
    local list = {
        oceanfish_small_1 = { --小孔雀鱼
            hardy = nil, pasty = nil, dusty = chance_high,
            meat = chance_med, veggie = chance_med, monster = chance_low
        },
        oceanfish_small_2 = { --针鼻喷墨鱼
            hardy = nil, pasty = chance_med, dusty = chance_high,
            meat = chance_med, veggie = chance_med, monster = chance_low
        },
        oceanfish_small_3 = { --小饵鱼
            hardy = chance_low, pasty = chance_med, dusty = chance_high,
            meat = chance_high, veggie = nil, monster = nil
        },
        oceanfish_small_4 = { --三文鱼苗
            hardy = chance_med, pasty = nil, dusty = chance_high,
            meat = chance_med, veggie = chance_med, monster = chance_low
        },
        oceanfish_small_5 = { --爆米花鱼
            hardy = nil, pasty = chance_lit, dusty = chance_lit,
            meat = nil, veggie = chance_lit, monster = nil,
            comical = 0.2
        },
        oceanfish_small_6 = { --落叶比目鱼
            hardy = 0, pasty = nil, dusty = nil,
            meat = nil, veggie = 0, monster = nil,
            wrinkled = 0.01
        },
        oceanfish_small_7 = { --花朵金枪鱼
            hardy = 0, pasty = 0, dusty = nil,
            meat = nil, veggie = 0, monster = nil,
            fragrant = 0.01
        },
        oceanfish_small_8 = { --炽热太阳鱼
            hardy = nil, pasty = nil, dusty = 0,
            meat = 0, veggie = nil, monster = nil,
            hot = 0.01
        },
        oceanfish_small_9 = { --口水鱼
            hardy = nil, pasty = 0, dusty = 0,
            meat = nil, veggie = 0, monster = nil,
            slippery = 0.1
        },
        oceanfish_medium_1 = { --泥鱼
            hardy = chance_high, pasty = nil, dusty = nil,
            meat = chance_med, veggie = chance_med, monster = chance_med
        },
        oceanfish_medium_2 = { --斑鱼
            hardy = chance_high, pasty = chance_high, dusty = nil,
            meat = chance_high, veggie = nil, monster = nil
        },
        oceanfish_medium_3 = { --浮夸狮子鱼
            hardy = chance_high, pasty = chance_med, dusty = nil,
            meat = chance_high, veggie = nil, monster = chance_med
        },
        oceanfish_medium_4 = { --黑鲶鱼
            hardy = chance_high, pasty = nil, dusty = nil,
            meat = chance_high, veggie = nil, monster = chance_high
        },
        oceanfish_medium_5 = { --玉米鳕鱼
            hardy = chance_low, pasty = chance_lit, dusty = nil,
            meat = nil, veggie = chance_lit, monster = nil,
            comical = 0.2
        },
        oceanfish_medium_6 = { --花锦鲤
            hardy = nil, pasty = nil, dusty = 0,
            meat = 0, veggie = 0, monster = nil,
            lucky = 0.1
        },
        oceanfish_medium_7 = { --金锦鲤
            hardy = nil, pasty = nil, dusty = 0,
            meat = 0, veggie = 0, monster = nil,
            lucky = 0.1
        },
        oceanfish_medium_8 = { --冰鲷鱼
            hardy = nil, pasty = 0, dusty = nil,
            meat = 0, veggie = 0, monster = 0,
            frozen = 0.01
        },
        oceanfish_medium_9 = { --甜味鱼
            hardy = nil, pasty = nil, dusty = 0,
            meat = nil, veggie = 0, monster = nil,
            sticky = 0.1
        },
        squid = { --鱿鱼
            hardy = 0, pasty = 0, dusty = 0,
            meat = 0, veggie = nil, monster = 0,
            shiny = 0.02
        },
        shark = { --岩石大白鲨
            hardy = nil, pasty = 0, dusty = 0,
            meat = 0, veggie = nil, monster = 0,
            bloody = 0.02
        },
        gnarwail = { --一角鲸
            hardy = 0, pasty = nil, dusty = nil,
            meat = 0, veggie = nil, monster = nil,
            whispering = 0.04
        },
        wobster_sheller = { --龙虾
            hardy = nil, pasty = nil, dusty = 0,
            meat = nil, veggie = nil, monster = 0,
            rotten = 0.1
        },
        wobster_moonglass = { --月光龙虾
            hardy = nil, pasty = 0, dusty = nil,
            meat = nil, veggie = nil, monster = nil,
            rusty = 0.1
        },
        spider_water = { --海黾
            hardy = nil, pasty = nil, dusty = 0,
            meat = 0, veggie = nil, monster = 0,
            shaking = 0.1
        },
        grassgator = { --草鳄鱼
            hardy = nil, pasty = nil, dusty = 0,
            meat = nil, veggie = 0, monster = nil,
            grassy = 0.04
        },
        puffin = { --海鹦鹉
            hardy = nil, pasty = nil, dusty = 0,
            meat = nil, veggie = nil, monster = nil,
            frizzy = 0.06
        },
        malbatross = { --邪天翁
            hardy = nil, pasty = nil, dusty = nil,
            meat = nil, veggie = nil, monster = 0,
            evil = 0.09
        },
    }

    if TheWorld.state.isspring then
        list.oceanfish_small_7.fragrant = 0.1
    elseif TheWorld.state.issummer then
        list.oceanfish_small_8.hot = 0.1
    elseif TheWorld.state.isautumn then
        list.oceanfish_small_6.wrinkled = 0.1
    else
        list.oceanfish_medium_8.frozen = 0.1
    end

    if self.ongetpreysfn ~= nil then
        self.ongetpreysfn(self.inst, preys, list)
    end

    local allweight = 0
    local weight = 0
    local specialchance = 0
    local specialmult = 1
    for prefab, data in pairs(list) do
        if data ~= nil then
            if self.type_special ~= nil then
                for k, bo in pairs(self.type_special) do
                    if bo and data[k] ~= nil then
                        specialchance = specialchance + data[k]
                    end
                end
            end

            if specialchance > 0 then --说明是特殊对象
                if data[self.type_eat] ~= nil then
                    specialmult = specialmult + 0.25
                end
                if data[self.type_shape] ~= nil then
                    specialmult = specialmult + 0.25
                end

                if preys.special == nil then
                    preys.special = {}
                end
                preys.special[prefab] = specialchance * specialmult
            else
                if data[self.type_eat] ~= nil then
                    weight = weight + data[self.type_eat]
                end
                if data[self.type_shape] ~= nil then
                    weight = weight + data[self.type_shape]
                end
                if weight > 0 then
                    if preys.normal == nil then
                        preys.normal = {}
                    end
                    preys.normal[prefab] = { min = allweight, max = allweight + weight }
                    allweight = allweight + weight
                end
            end

            weight = 0
            specialchance = 0
            specialmult = 1
        end
    end

    if preys.normal ~= nil or preys.special ~= nil then
        if allweight > 0 then
            preys.allweight = allweight
        end
    end
    return preys
end

local function Describe(inst, context)
    local descriptions = {}
    -- period and count
    local periodtime = 6
    if inst.type_shape == "hardy" then
        periodtime = 16
    elseif inst.type_shape == "pasty" then
        periodtime = 10
    else
        periodtime = 6
    end
    descriptions[#descriptions + 1] = { name = "fish_prey", priority = 2, description = string.format(tr.times, periodtime, inst.times) }

    -- spawn possibilities
    local preys = inst.preys or GetPrey(inst)
    if preys then
        if preys.special then
            local possibility = {}
            for key, value in pairs(preys.special) do
                possibility[#possibility + 1] = string.format("<prefab=%s><color=NATURE><sub>%d%%</sub></color>", key, math.floor(value * 100))
            end

            descriptions[#descriptions + 1] = {
                name = "fish_prey",
                priority = 1,
                description = tr.special_prefix .. table.concat(possibility, tr.special_sep)
            }
        end
        if preys.normal and preys.allweight then
            local lines = {}
            local possibility = {}
            for key, value in pairs(preys.normal) do
                possibility[#possibility + 1] = string.format("<prefab=%s><color=WET><sub>%d%%</sub></color>", key, math.floor((value.max - value.min) / preys.allweight * 100))
                if #possibility == 3 then
                    lines[#lines + 1] = table.concat(possibility, tr.normal_sep)
                    possibility = {}
                end
            end
            if #possibility ~= 0 then
                lines[#lines + 1] = table.concat(possibility, tr.normal_sep)
            end
            descriptions[#descriptions + 1] = {
                name = "fish_prey",
                priority = 0,
                description = tr.normal_prefix .. table.concat(lines, "\n")
            }
        end
    end

    return unpack(descriptions)

end

return { Describe = Describe }
