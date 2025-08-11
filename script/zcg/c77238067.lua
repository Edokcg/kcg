--规则守护者之封锁二(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	if aux.IsKCGScript then
		e0:SetCode(EVENT_PREDRAW)
	else 
		e0:SetCode(EVENT_PREDRAW)
	end
	if aux.IsKCGScript then
	   e0:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	else
	   e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	end
	e0:SetRange(LOCATION_DECK)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(0xff)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsAbleToRemove() and (c:IsSetCard(0xa60) or c:IsSetCard(0xa150)
or c:IsSetCard(0xa13) or c:IsSetCard(0xa71) or c:IsSetCard(0xa90) or c:IsSetCard(0xa90) or 
c:IsSetCard(0x145) or c:IsRace(RACE_DIVINE) or c:IsRace(0x100000000) or c:IsSetCard(0xcf)
or c:IsSetCard(0xa50) or c:IsSetCard(0x6e))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,0x1ff,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,0,0x1ff,nil)
	Duel.Remove(g,POS_FACEUP,REASON_RULE)
	local ng=Duel.GetOperatedGroup()
	local tc=ng:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e1,true)
		tc=ng:GetNext()
	end
Duel.SendtoDeck(c,tp,-2,REASON_RULE)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end




















