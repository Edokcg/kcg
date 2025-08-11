--千年青龙
function c77239475.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --remain field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e2)
	
    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239475,0))	
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)	
    e3:SetTarget(c77239475.target)
    e3:SetOperation(c77239475.activate)
    c:RegisterEffect(e3)	

    --Activate
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239475,1))	
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)	
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e4:SetTarget(c77239475.target1)
    e4:SetOperation(c77239475.activate1)
    c:RegisterEffect(e4)	
end
--------------------------------------------------------------------
function c77239475.tgfilter(c)
    return c:IsAbleToHand()
end
function c77239475.tgfilter1(c)
    return c:IsAbleToDeck()
end
function c77239475.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and (c77239475.tgfilter(chkc) or c77239475.tgfilter1(chkc))  end
    if chk==0 then return Duel.IsExistingTarget(c77239475.tgfilter,tp,LOCATION_GRAVE,0,2,nil) or Duel.IsExistingTarget(c77239475.tgfilter1,tp,LOCATION_GRAVE,0,2,nil) end
    local op=0
    op=Duel.SelectOption(tp,aux.Stringid(77239475,2),aux.Stringid(77239475,3))
    e:SetLabel(op)
    if op==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=Duel.SelectTarget(tp,c77239475.tgfilter,tp,LOCATION_GRAVE,0,2,2,nil)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=Duel.SelectTarget(tp,c77239475.tgfilter1,tp,LOCATION_GRAVE,0,2,2,nil)
        Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
    end
end
function c77239475.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local t=e:GetLabel()
    if t==0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    else
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
--------------------------------------------------------------------
function c77239475.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239475.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c77239475.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c77239475.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c77239475.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77239475.activate1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end


