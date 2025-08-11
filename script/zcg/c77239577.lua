--这颗行星的生日歌
function c77239577.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)	
    e4:SetRange(LOCATION_FZONE)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetCondition(c77239577.con)
    e4:SetOperation(c77239577.activate)
    c:RegisterEffect(e4)
end
function c77239577.con(e,tp,eg,ep,ev,re,r,rp)
    local ec=eg:GetFirst()
    return ec:IsReason(REASON_BATTLE)
end
function c77239577.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(Duel.GetTurnPlayer(),eg:GetCount(),REASON_EFFECT)
end
