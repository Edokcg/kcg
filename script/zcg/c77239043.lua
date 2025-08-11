--乾坤之师
function c77239043.initial_effect(c)
	--提升攻击
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c77239043.atkcon)
	e1:SetOperation(c77239043.atkop)
	c:RegisterEffect(e1)
	
	--handes
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)	
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c77239043.condition)	
	e2:SetTarget(c77239043.target)
	e2:SetOperation(c77239043.operation)
	c:RegisterEffect(e2)	
end
--------------------------------------------------------
function c77239043.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239043.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
	    local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetRange(LOCATION_MZONE)
        e2:SetTargetRange(LOCATION_MZONE,0)
        e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FIEND))
        e2:SetValue(200)
        c:RegisterEffect(e2)
	end
end
------------------------------------------------------
function c77239043.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c77239043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,0,1-tp,1)
end
function c77239043.operation(e,tp,eg,ep,ev,re,r,rp)
    local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
    if rg:GetCount()>0 then
        Duel.ConfirmCards(tp,rg)
        local g=rg:Select(tp,1,1,nil)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

