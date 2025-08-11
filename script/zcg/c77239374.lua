--殉道者造卡器
function c77239374.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_DRAW_PHASE)
    e1:SetCondition(c77239374.con)
    e1:SetTarget(c77239374.target)
    e1:SetOperation(c77239374.operation)
    c:RegisterEffect(e1)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239374.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239374.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239374.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77239374.disop)
    c:RegisterEffect(e13)
end
function c77239374.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_DRAW
end
function c77239374.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    local ht1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    if chk==0 then return ht<ht1 and Duel.IsPlayerCanDraw(tp,ht1-ht) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ht1-ht)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ht1-ht)
end
function c77239374.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end

function c77239374.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239374.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239374.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end