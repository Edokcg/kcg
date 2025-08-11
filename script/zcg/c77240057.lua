--回吸
function c77240057.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(54959865,0))
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c77240057.target)
    e1:SetOperation(c77240057.operation)
    c:RegisterEffect(e1)
end
function c77240057.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_MZONE,0,nil,RACE_ZOMBIE)>0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c77240057.operation(e,tp,eg,ep,ev,re,r,rp)
    local rt=Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_MZONE,0,nil,RACE_ZOMBIE)*500
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Recover(p,rt,REASON_EFFECT)
end
