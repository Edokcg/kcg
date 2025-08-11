--双生猫咪
function c77239045.initial_effect(c)
	--不会被战斗破坏
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77239045.ebcon)
	c:RegisterEffect(e1)

    --可当作2个祭品
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e2:SetValue(c77239045.dtcon)
    c:RegisterEffect(e2)	
end
function c77239045.ebcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c77239045.dtcon(e,c)
    return c:IsRace(RACE_ALL)
end