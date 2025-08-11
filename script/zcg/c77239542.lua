--甜蜜的婚礼
function c77239542.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c77239542.condition)	
    e1:SetTarget(c77239542.target)
    e1:SetOperation(c77239542.activate)
    c:RegisterEffect(e1)
end
--------------------------------------------------------------
function c77239542.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp 
end
function c77239542.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239542.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,nil)
    local g=Duel.GetDecktopGroup(tp,5):Filter(c77239542.filter,nil,e,tp)   
	Duel.Destroy(sg,REASON_EFFECT)
    Duel.Draw(1-tp,5,REASON_EFFECT)
    if g:GetCount()>0 and Duel.Draw(tp,5,REASON_EFFECT) then	
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,2,nil)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end		
end
function c77239542.filter(c,e,tp)
    return c:IsSetCard(0xa80) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end


