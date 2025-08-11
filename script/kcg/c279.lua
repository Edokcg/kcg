--Doom Virus Dragon
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,false,57728570,280)
	
	--Doom Virus (Faceup)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.adjustcon) 
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_MSET)
	e2:SetOperation(s.chkop)
	c:RegisterEffect(e2)
end
s.listed_names={57728570,280}
s.material_trap=57728570

function s.adjustcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_MZONE,e:GetHandler())>0
end
function s.filter(c)
	return c:IsFaceup() and c:GetAttack()>=1500 and c:IsDestructable()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,c)
	local conf=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,c)
	if #conf>0 then
		Duel.ConfirmCards(tp,conf)
		g:Merge(conf)
	end
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.filter2(c)
	return c:IsFacedown() and c:IsAttackAbove(1500) and c:IsDestructable()
end
function s.chkop(e,tp,eg,ep,ev,re,r,rp)
	local conf=Duel.GetFieldGroup(tp,0,LOCATION_MZONE,POS_FACEDOWN)
	if #conf>0 then
		Duel.ConfirmCards(tp,conf)
	end
end