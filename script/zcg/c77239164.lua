--奥西里斯的制裁
function c77239164.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239164,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)	
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCost(c77239164.cost)
    e2:SetTarget(c77239164.target)
    e2:SetOperation(c77239164.operation)
    c:RegisterEffect(e2)
	
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239164,1))
    e3:SetCategory(CATEGORY_HANDES)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCost(c77239164.cost)
    e3:SetTarget(c77239164.target1)
    e3:SetOperation(c77239164.operation1)
    c:RegisterEffect(e3)	
end
----------------------------------------------------------------
function c77239164.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
    local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
    Duel.Release(sg,REASON_COST)
end
function c77239164.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239164.operation(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local g=tg:Filter(Card.IsRelateToEffect,nil,e)
    Duel.SendtoGrave(g,REASON_EFFECT)
    local g1=Duel.GetOperatedGroup()	
    local sg=g1:Filter(c77239164.cfilter,nil,e,tp)
    if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77239164,2)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sdg=sg:Select(tp,2,2,nil)
        Duel.SpecialSummon(sdg,0,tp,tp,true,true,POS_FACEUP)
    end
end
function c77239164.cfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and  c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
----------------------------------------------------------------
function c77239164.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>1 end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
end
function c77239164.operation1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g:GetCount()>1 then
        Duel.ConfirmCards(tp,g)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local xg=g:Select(tp,2,2,nil)
        Duel.SendtoGrave(xg,REASON_EFFECT+REASON_DISCARD)     
        Duel.ShuffleHand(1-tp)
		local g1=Duel.GetOperatedGroup()
		local sg=g1:Filter(c77239164.cfilter,nil,e,tp)
        if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77239164,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sdg=sg:Select(tp,2,2,nil)
            Duel.SpecialSummon(sdg,0,tp,tp,true,true,POS_FACEUP)
        end
    end
end





