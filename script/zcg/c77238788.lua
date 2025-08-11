--真红眼电子龙(ZCG)
function c77238788.initial_effect(c)
    --damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238788,0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLED)
    e1:SetCondition(c77238788.condition)
    e1:SetTarget(c77238788.target)
    e1:SetOperation(c77238788.operation)
    c:RegisterEffect(e1)

    --flip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77238788,0))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e2:SetTarget(c77238788.target2)
    e2:SetOperation(c77238788.operation2)
    c:RegisterEffect(e2)
end
------------------------------------------------------------------
function c77238788.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local pos=c:GetBattlePosition()
    return c==Duel.GetAttackTarget() and (pos==POS_FACEDOWN_DEFENSE or pos==POS_FACEDOWN_ATTACK) and c:IsLocation(LOCATION_MZONE)
end
function c77238788.filter(c)
    return c:IsAbleToHand()
end
function c77238788.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c77238788.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77238788.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77238788.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
------------------------------------------------------------------
function c77238788.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77238788.operation2(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
