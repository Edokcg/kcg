--黑魔導女孩 黄将(ZCG)
function c77239958.initial_effect(c)
    --battle indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e1:SetCountLimit(1)
    e1:SetValue(c77239958.valcon)
    c:RegisterEffect(e1)

    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCondition(c77239958.condition)
    e2:SetTarget(c77239958.target)
    e2:SetOperation(c77239958.operation)
    c:RegisterEffect(e2)	
end
-----------------------------------------------------------------
function c77239958.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
-----------------------------------------------------------------
function c77239958.filter(c)
    return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c77239958.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c77239958.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c77239958.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c77239958.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(c77239958.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    local sg=Duel.GetOperatedGroup()
    local g=sg:Filter(c77239958.filter1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.ConfirmCards(1-tp,sg)
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        Duel.ShuffleHand(tp)
    end
end
function c77239958.filter1(c,e,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end


