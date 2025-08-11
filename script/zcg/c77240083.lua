--墓地炸弹
function c77240083.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77240083.target)
    e1:SetOperation(c77240083.activate)
    c:RegisterEffect(e1)
end
function c77240083.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)>0 end
    Duel.SetTargetPlayer(1-tp)
    local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)*1000
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77240083.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)*1000
    Duel.Damage(p,dam,REASON_EFFECT)
end