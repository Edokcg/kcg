--無名之龍-海聂默斯之爪融合 (K)
function c44.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	--cannot special summon
	-- local e0=Effect.CreateEffect(c)
	-- e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e0:SetType(EFFECT_TYPE_SINGLE)
	-- e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- e0:SetValue(c44.splimit)
	-- c:RegisterEffect(e0)

    --Equip Limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetValue(c44.eqlimit)
    c:RegisterEffect(e3)
end 

function c44.eqlimit(e,c)
       return c:IsFaceup()
end

-- function c44.splimit(e,se,sp,st)
-- 	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
-- end

