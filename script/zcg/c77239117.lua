--神石板 翼神龙之光(ZCG)
function c77239117.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c77239117.ttcon)
	e1:SetOperation(c77239117.ttop)
	--e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	
    --不会被战斗破坏
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(c77239117.batfilter)
    c:RegisterEffect(e2)	
	
    --不会造成战斗伤害
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e3:SetValue(1)
    c:RegisterEffect(e3)

	--不能召唤、特殊召唤
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_SUMMON)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,1)
    e4:SetTarget(c77239117.sumlimit)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    c:RegisterEffect(e5)
end
-----------------------------------------------------------
function c77239117.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239117.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
-----------------------------------------------------------
function c77239117.batfilter(e,c)
    return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
-----------------------------------------------------------
function c77239117.sumlimit(e,c)
    return not c:IsAttribute(ATTRIBUTE_LIGHT)
end



