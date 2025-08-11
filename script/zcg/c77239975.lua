--魔法引力(ZCG)
function c77239975.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239975,0))
    e2:SetCategory(CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e2:SetTarget(c77239975.target)
    e2:SetOperation(c77239975.operation)
    c:RegisterEffect(e2)
	
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239975,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE) 
    e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e3:SetTarget(c77239975.destg)
    e3:SetOperation(c77239975.desop)
    c:RegisterEffect(e3)	
end
-----------------------------------------------------------------------------
function c77239975.filter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c77239975.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239975.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239975.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239975.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-----------------------------------------------------------------------------
function c77239975.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ng=Duel.GetMatchingGroupCount(c77239975.desfilter,tp,LOCATION_MZONE,0,nil)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return ng>0 and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ng,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239975.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(g,REASON_EFFECT)
end
function c77239975.desfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end

