--奥利哈刚 黑暗气息(ZCG)
function c77239244.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c77239244.target)
    e1:SetOperation(c77239244.activate)
    c:RegisterEffect(e1)    
end
-------------------------------------------------------------------------
function c77239244.filter(c)
    return aux.TRUE and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239244.filter2(c)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174))) and c:IsFaceup()
end
function c77239244.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local gc=Duel.GetMatchingGroupCount(c77239244.filter2,tp,LOCATION_MZONE,0,nil)
    local mc=Duel.GetTargetCount(c77239244.filter,tp,0,LOCATION_ONFIELD,nil)
    if chkc then return chkc:IsOnField() and c77239244.filter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return mc>0 and gc>0 end
    if mc<gc then gc=mc end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c77239244.filter,tp,0,LOCATION_ONFIELD,gc,gc,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c77239244.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()<1 then return end
    local tc=sg:GetFirst()
    while tc do
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            e3:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e3)
        end
        Duel.Destroy(tc,REASON_EFFECT)
        tc=sg:GetNext()
    end
end
