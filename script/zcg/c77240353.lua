--不死之猛毒药剂(ZCG)
local s,id=GetID()
function s.initial_effect(c)
			--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(s.rectg)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER)
end
function s.filter2(c)
	return c:IsType(TYPE_MONSTER)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)
	local ct2=Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*200)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)
	local ct2=Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_ONFIELD,nil)
	local cct=Duel.GetMatchingGroupCount(s.filter2,tp,LOCATION_ONFIELD,0,nil)
	local cct2=Duel.GetMatchingGroupCount(s.filter2,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 then
		Duel.Recover(tp,ct*200,REASON_EFFECT)
	else
		Duel.Damage(tp,cct*200,REASON_EFFECT)
	end
	if ct2>0 then
	 Duel.Recover(1-tp,ct2*200,REASON_EFFECT)
	else
		Duel.Damage(1-tp,cct2*200,REASON_EFFECT)
	end
end


