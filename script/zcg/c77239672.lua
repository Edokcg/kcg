--钢钻侠
function c77239672.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c77239672.damcon)
    e1:SetTarget(c77239672.damtg)
    e1:SetOperation(c77239672.damop)
    c:RegisterEffect(e1)
	
	--[[
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SSET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c77239672.con)
    e2:SetOperation(c77239672.op)
    c:RegisterEffect(e2)]]

    --Damage
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SSET_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	e2:SetCost(c77239672.costchk)
	e2:SetOperation(c77239672.costop)
	c:RegisterEffect(e2)
end
------------------------------------------------------------------------
function c77239672.damcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c77239672.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)*500
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,dam)
end
function c77239672.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
------------------------------------------------------------------------
--[[function c77239672.cfilter(c,tp)
    return c:IsFacedown() and c:IsControler(1-tp) and c:IsLocation(LOCATION_SZONE)
end
function c77239672.con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239672.cfilter,1,nil,tp)
end
function c77239672.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,500,REASON_EFFECT)
end]]

function c77239672.costchk(e,te_or_c,tp)
	local ct=#{Duel.GetPlayerEffect(tp,77239672)}
	return Duel.CheckLPCost(tp,ct*500)
end
function c77239672.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,77239672)
	Duel.PayLPCost(tp,500)
end
