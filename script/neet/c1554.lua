--死狱乡演员·圣餐祷告者(neet)
local s,id=GetID()
function s.initial_effect(c)
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x166),s.matfilter)
	c:EnableReviveLimit()   
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_ATKCHANGE)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE)
	e0:SetHintTiming(0,TIMING_MAIN_END)
	e0:SetCountLimit(1,{id,0})
	e0:SetCondition(s.discon)
	e0:SetTarget(s.distg)
	e0:SetOperation(s.disop)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,{id,1})
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
end
s.material_setcode=0x166
function s.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsLocation(LOCATION_MZONE)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.disfilter(c)
	return c:IsFaceup() and c:IsNegatable() and not (c:IsType(TYPE_FUSION) and c:IsLevelAbove(8))
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,#g,PLAYER_ALL,LOCATION_MZONE)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in g:Iter() do
		tc:NegateEffects(c,RESET_PHASE|PHASE_END,true)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3206)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function s.atkfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,c,c:GetAttack())
end
function s.cfilter(c,atk)
	return c:GetAttack()~=atk and c:IsFaceup()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,0,nil,tp)
	if #g==0 then return end
	local fg=g:GetMaxGroup(Card.GetAttack)
	local fc=fg:GetFirst()
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,fc)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(fc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(fc:GetDefense())
		tc:RegisterEffect(e2)
	end
end