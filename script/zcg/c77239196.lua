--修特姆贝洛克的黄金城(ZCG)
function c77239196.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c77239196.op)	
    c:RegisterEffect(e1)
	
    --Discard half deck
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)	
    e2:SetCondition(c77239196.condition)
    e2:SetOperation(c77239196.mtop)
    c:RegisterEffect(e2)
end
-------------------------------------------------------------------------------------
function c77239196.filter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239196.op(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft>1 and Duel.SelectYesNo(tp,aux.Stringid(22567609,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c77239196.filter,tp,LOCATION_DECK,0,ft,ft,nil,e,tp)
        if g:GetCount()>0 then
            local tc=g:GetFirst()
            while tc do
                Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
                tc=g:GetNext()
            end
        end
	end
end
-------------------------------------------------------------------------------------
function c77239196.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239196.costfilter(c)
    return c:IsAbleToGrave()
end
function c77239196.mtop(e,tp,eg,ep,ev,re,r,rp)
    local g2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
    local gc=Duel.GetMatchingGroup(c77239196.costfilter,1-tp,LOCATION_DECK,0,nil):RandomSelect(1-tp,math.floor(g2/2))
    Duel.SendtoGrave(gc,REASON_COST)
end
