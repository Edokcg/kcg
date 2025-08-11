--古代的机械青眼白龙
function c77239141.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239141.spcon)
    e1:SetOperation(c77239141.spop)
    c:RegisterEffect(e1)

    --pos
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239141,0))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetTarget(c77239141.tg)
    e2:SetOperation(c77239141.op)
    c:RegisterEffect(e2)	
end
----------------------------------------------------------------
function c77239141.spfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost()
end
function c77239141.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239141.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c77239141.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239141.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(g:GetFirst():GetAttack())
    e1:SetReset(RESET_EVENT+0xff0000)
    e:GetHandler():RegisterEffect(e1)
end
----------------------------------------------------------------
function c77239141.filter(c)
    return c:IsRace(RACE_DRAGON) and not c:IsPublic()
end
function c77239141.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239141.filter,tp,LOCATION_HAND,0,1,nil) end
end
function c77239141.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77239141.filter,tp,LOCATION_HAND,0,nil,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg=g:Select(tp,1,1,nil)
        Duel.ConfirmCards(1-tp,sg)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
        e1:SetTargetRange(0,1)
        e1:SetValue(c77239141.aclimit)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
        Duel.RegisterEffect(e1,tp)
        Duel.ShuffleHand(tp)
	end	
end
function c77239141.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end




