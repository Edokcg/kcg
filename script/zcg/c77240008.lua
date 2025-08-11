--ブラック・マジシャン・マスター
function c77240008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77240008.spcon)
	e1:SetOperation(c77240008.spop)
	c:RegisterEffect(e1)
	--unaffectable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c77240008.efilter)
	c:RegisterEffect(e2)
	--attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c77240008.atkval)
	c:RegisterEffect(e3)
end
function c77240008.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.CheckLPCost(c:GetControler(),500)
end
function c77240008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,500)
end
function c77240008.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c77240008.cfilter(c)
	return c:IsSetCard(0x10a2)
end
function c77240008.atkval(e,c)
	local g=Duel.GetMatchingGroup(c77240008.cfilter,c:GetControler(),0x13,0,nil)
	return g:GetSum(Card.GetAttack)
end
