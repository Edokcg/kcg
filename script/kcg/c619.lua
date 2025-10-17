-- CNo. 混沌超量體
local s, id = GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()

    -- local e8 = Effect.CreateEffect(c)
    -- e8:SetType(EFFECT_TYPE_SINGLE)
    -- e8:SetCode(EFFECT_DISABLE)
    -- e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    -- e8:SetRange(LOCATION_MZONE)
    -- e8:SetCondition(function(...)
    --     return Duel.GetLP(c:GetControler()) > 1000
    -- end)
    -- c:RegisterEffect(e8, true)
    -- local e82 = e8:Clone()
    -- e82:SetCode(EFFECT_DISABLE_EFFECT)
    -- c:RegisterEffect(e82, true)

    -- battle indestructable
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard, 0x48)))
    c:RegisterEffect(e3)

    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(s.condition)
	e1:SetCost(Cost.AND(Cost.DetachFromSelf(1),s.cost))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series = {0x48}

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and Duel.GetLP(tp)<=1000
end
function s.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c) 
		and Duel.IsExistingTarget(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	if #g<1 then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:SetLabel(g:GetFirst():GetAttack())
end
function s.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetTargetParam(e:GetLabel())
	e:SetLabel(0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    local atk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
