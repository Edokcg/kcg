--殉道者 地狱狱卒
function c77240152.initial_effect(c)
    --skip draw
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77240152.skipcon)
    e1:SetOperation(c77240152.skipop)
    c:RegisterEffect(e1)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240152.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240152.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240152.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77240152.disop)
    c:RegisterEffect(e13)
end
---------------------------------------------------------------------
function c77240152.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c77240152.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCode(EFFECT_SKIP_DP)
	--e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_DRAW then
        e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
    else
        e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
    end
	Duel.RegisterEffect(e2,tp)
end
---------------------------------------------------------------------
function c77240152.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240152.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240152.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end