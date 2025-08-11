--反转抽卡
function c77239161.initial_effect(c)
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_DAMAGE)
    e1:SetTarget(c77239161.rectg)
    e1:SetOperation(c77239161.activate)
    c:RegisterEffect(e1)
end
function c77239161.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return ep==tp and Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c77239161.activate(e,tp,eg,ep,ev,re,r,rp)
    local h1=Duel.Draw(tp,2,REASON_EFFECT)
    local g1=Duel.GetOperatedGroup()	
    local h2=Duel.Draw(1-tp,2,REASON_EFFECT)
    local g2=Duel.GetOperatedGroup()	
    Duel.ConfirmCards(1-tp,g1)
    Duel.ConfirmCards(tp,g2)
    local sg=g1:Filter(c77239161.cfilter,nil,e,tp)
    if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77239161,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sdg=sg:Select(tp,2,2,nil)
        Duel.SpecialSummon(sdg,0,tp,tp,false,false,POS_FACEUP)
    end
    local sg2=g2:Filter(c77239161.cfilter1,nil)
    if sg2:GetCount()>0 then	
	    Duel.Recover(tp,2000,REASON_EFFECT)
	end
    Duel.ShuffleHand(tp)
    Duel.ShuffleHand(1-tp)	
end
function c77239161.cfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239161.cfilter1(c,e,tp)
    return c:IsType(TYPE_MONSTER)
end