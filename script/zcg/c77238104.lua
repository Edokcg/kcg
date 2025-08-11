--不死之青眼白龙
function c77238104.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77238104.val)
    c:RegisterEffect(e1)
	
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77238104,1))
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c77238104.discon)
    e2:SetCost(c77238104.discost)
    e2:SetTarget(c77238104.distg)
    e2:SetOperation(c77238104.disop)
    c:RegisterEffect(e2)	
end
--------------------------------------------------------------------
function c77238104.val(e,c)
    return Duel.GetMatchingGroupCount(c77238104.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end
function c77238104.filter(c)
    return c:IsRace(RACE_ZOMBIE)
end
--------------------------------------------------------------------
function c77238104.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return tg and tg:IsContains(c) and Duel.IsChainNegatable(ev)
end
function c77238104.cfilter(c)
    return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_ZOMBIE)
end
function c77238104.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77238104.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    local g=Duel.SelectMatchingCard(tp,c77238104.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77238104.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c77238104.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
end


