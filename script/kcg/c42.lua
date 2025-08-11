--無名之龍-提瑪歐斯之眼融合 (K)
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
    --cannot special summon
	-- local e0=Effect.CreateEffect(c)
	-- e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e0:SetType(EFFECT_TYPE_SINGLE)
	-- e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- e0:SetValue(c42.splimit)
	-- c:RegisterEffect(e0)
end

-- function c42.splimit(e,se,sp,st)
-- 	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
-- end