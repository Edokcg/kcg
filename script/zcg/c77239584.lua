--暗黑摄取(ZCG)
function c77239584.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239584.target)
    e1:SetOperation(c77239584.activate)
    c:RegisterEffect(e1)
end
function c77239584.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return  Duel.IsPlayerCanDraw(tp,3) and Duel.IsPlayerCanDraw(1-tp,3) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c77239584.activate(e,tp,eg,ep,ev,re,r,rp)
    local h1=Duel.Draw(tp,3,REASON_EFFECT)
    local g1=Duel.GetOperatedGroup()    
    local h2=Duel.Draw(1-tp,3,REASON_EFFECT)
    local g2=Duel.GetOperatedGroup()
    local sg=g1:Filter(c77239584.cfilter,nil,e,tp)
    Duel.ConfirmCards(1-tp,g1)  
    Duel.ConfirmCards(tp,g2)    
    if sg:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sdg=sg:Select(tp,sg:GetCount(),sg:GetCount(),nil)
        Duel.SpecialSummon(sdg,0,tp,tp,false,false,POS_FACEUP)
        g1:Sub(sdg)
    end
    local sg2=g2:Filter(c77239584.cfilter1,nil,e,1-tp)
    if sg2:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
        local sdg1=sg2:Select(1-tp,sg2:GetCount(),sg2:GetCount(),nil)
        Duel.SpecialSummon(sdg1,0,1-tp,1-tp,false,false,POS_FACEUP)
        g2:Sub(sdg1)
    end
    Duel.SendtoGrave(g1,REASON_EFFECT)
    Duel.SendtoGrave(g2,REASON_EFFECT)    
end
function c77239584.cfilter(c,e,tp)
    return c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239584.cfilter1(c,e,tp)
    return c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
end
