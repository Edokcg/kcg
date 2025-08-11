--极狱之裁决(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_DESTROYED)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e0:SetCountLimit(1,id)
	e0:SetCondition(s.condition)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(Cost.SelfBanish)
	e1:SetTarget(s.target2)
	e1:SetOperation(s.activate2)
	c:RegisterEffect(e1)  
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	if des:IsReason(REASON_BATTLE) then
		local rc=des:GetReasonCard()
		return rc and rc:IsSetCard(0x1045) and rc:IsControler(tp) and rc:IsRelateToBattle()
	elseif re then
		local rc=re:GetHandler()
		return eg:IsExists(s.cfilter,1,nil,tp)
			and rc and rc:IsSetCard(0x1045) and rc:IsControler(tp) and re:IsActiveType(TYPE_MONSTER)
	end
	return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg,matk=eg:GetMaxGroup(Card.GetBaseAttack)
	if chk==0 then return matk>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,matk,1-tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg,matk=eg:GetMaxGroup(Card.GetBaseAttack)
	Duel.Damage(1-tp,matk,REASON_EFFECT)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #eg*500>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,#eg*500,1-tp,0)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local mg,matk=eg:GetMaxGroup(Card.GetBaseAttack)
	Duel.Damage(1-tp,#eg*500,REASON_EFFECT)
end