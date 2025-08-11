--断言术(ZCG)
function c77239178.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --[[attack cost
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_ATTACK_COST)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(0,1)
    e2:SetCost(c77239178.atcost)
    e2:SetOperation(c77239178.atop)
    c:RegisterEffect(e2)
    --accumulate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(0x10000000+77239178)
    e3:SetRange(LOCATION_SZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(0,1)
    c:RegisterEffect(e3)]]
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_SZONE)	
	e2:SetCondition(c77239178.condition)
	e2:SetOperation(c77239178.activate)
	c:RegisterEffect(e2)
end
--[[function c77239178.atcost(e,c,tp)
    local ct=Duel.GetFlagEffect(tp,77239178)
    return Duel.IsPlayerCanDiscardDeckAsCost(tp,ct)
end
function c77239178.atop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(tp,2,REASON_COST)
end]]

function c77239178.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77239178.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,2,REASON_COST)
end