--ブリキンギョ
function c77239685.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetOperation(c77239685.spop)
    c:RegisterEffect(e1)
end
function c77239685.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)	
    e1:SetCountLimit(1)
    e1:SetCondition(c77239685.condition)
    e1:SetTarget(c77239685.target)
    e1:SetOperation(c77239685.operation)
    c:RegisterEffect(e1)
end
function c77239685.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c77239685.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,5) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(5)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end
function c77239685.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    local g1=Duel.GetOperatedGroup()
    Duel.ConfirmCards(1-tp,g1)
    local sg=g1:Filter(c77239685.cfilter,nil,e,tp)
    if sg:GetCount()>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sdg=sg:Select(tp,sg:GetCount(),sg:GetCount(),nil)
        Duel.SpecialSummon(sdg,0,tp,tp,false,false,POS_FACEUP)
    end	
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)	
end
function c77239685.cfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end