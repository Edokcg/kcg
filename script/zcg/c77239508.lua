--女子佣兵 暗灵(ZCG)
function c77239508.initial_effect(c)
    --discard deck
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239508,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCategory(CATEGORY_DECKDES)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c77239508.con)	
    e1:SetTarget(c77239508.distg)
    e1:SetOperation(c77239508.disop)
    c:RegisterEffect(e1)
end
-----------------------------------------------------------------
function c77239508.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetAttack()>=500
end
function c77239508.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,5,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function c77239508.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-500)
    c:RegisterEffect(e1)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(74191942,0))
    local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_DECK,nil)
    Duel.ConfirmCards(tp,g)
    local sg=g:Select(tp,5,5,nil)	
    Duel.SendtoGrave(sg,REASON_EFFECT)	
    local tg=sg:Filter(c77239508.cfilter,nil)
	local dam=tg:GetSum(Card.GetAttack)	
    Duel.Damage(1-tp,dam,REASON_EFFECT)          
end
function c77239508.cfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK)
end




