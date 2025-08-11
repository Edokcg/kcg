--卡通黑魔导
function c77240077.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77240077.spcon)
    c:RegisterEffect(e1)
	
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c77240077.val)
    c:RegisterEffect(e2)
	
    --direct attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    e4:SetCondition(c77240077.dircon)
    c:RegisterEffect(e4)

    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_CHAINING)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e5:SetCategory(CATEGORY_NEGATE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCost(c77240077.cost)
    e5:SetCondition(c77240077.negcon)
    e5:SetTarget(c77240077.neptg)
    e5:SetOperation(c77240077.negop)
    c:RegisterEffect(e5)
end
--------------------------------------------------------------------
function c77240077.cfilter(c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function c77240077.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()	
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c77240077.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
--------------------------------------------------------------------
function c77240077.cfilter1(c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function c77240077.cfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0x62)
end
function c77240077.dircon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(c77240077.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
        and not Duel.IsExistingMatchingCard(c77240077.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
--------------------------------------------------------------------
function c77240077.val(e,c)
    return Duel.GetMatchingGroupCount(c77240077.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*500
end
function c77240077.filter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x62)
end
--------------------------------------------------------------------
function c77240077.filter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
end
function c77240077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240077.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77240077.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77240077.nefilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x62) and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c77240077.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c77240077.nefilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c77240077.neptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c77240077.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(re:GetHandler(),REASON_EFFECT)
    end
end