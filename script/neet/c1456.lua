--自奏圣乐·肯忒萝丝（neet）
local s,id=GetID()
function s.initial_effect(c)
	--Link summon method
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,1,1)
--cannot be targeted
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.con)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
 --Choose Attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
--reflect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetTarget(s.reftg)
	e2:SetCondition(s.refcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
s.listed_series={0x11b}
function s.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x11b,lc,sumtype,tp) and not c:IsType(TYPE_LINK,lc,sumtype,tp)
end
function s.con(e)
	return e:GetHandler():IsLinked()
end
function s.cfilter(c)
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_DARK)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.reftg(e,c)
	return c:IsSetCard(0x11b)
end
function s.refcon(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	return t and t:IsFaceup() and t:IsSetCard(0x11b)
end
