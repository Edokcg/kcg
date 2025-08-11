--完全魔法引力
function c77239150.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239150.target)
    e1:SetOperation(c77239150.activate)
    c:RegisterEffect(e1)
end
function c77239150.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,10) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(10)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,10)
end
function c77239150.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()	
	Duel.ConfirmCards(1-tp,g)
    local sg=g:Filter(c77239150.cfilter2,nil,e,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)	
    if sg:GetCount()>0 and ft>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sdg=sg:Select(tp,1,ft,nil)
        Duel.SpecialSummon(sdg,0,tp,tp,false,false,POS_FACEUP)		
    end	
    g:Sub(sg)	
    Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)	
end
function c77239150.cfilter2(c,e,tp)
    return (c:IsCode(77239060) or c:IsCode(77239061) or c:IsSetCard(0x3a2e)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end