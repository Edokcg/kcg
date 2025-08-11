--六芒星 龙父(ZCG)
function c77239414.initial_effect(c)
	--破坏
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1)	
    e1:SetCost(c77239414.cost)
    e1:SetTarget(c77239414.target)
    e1:SetOperation(c77239414.operation)
    c:RegisterEffect(e1)
end
function c77239414.costfilter(c)
    return c:IsSetCard(0xa70) and c:IsType(TYPE_MONSTER) and c:IsDiscardable() 
end
function c77239414.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239414.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    local rt=Duel.GetTargetCount(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local cg=Duel.SelectMatchingCard(tp,c77239414.costfilter,tp,LOCATION_HAND,0,1,rt,nil)
    Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
    e:SetLabel(cg:GetCount())
end
function c77239414.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    local ct=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local eg=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,ct,0,0)
end
function c77239414.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
        Duel.Destroy(rg,REASON_EFFECT)
end
