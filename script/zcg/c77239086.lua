--超黑魔导神官
function c77239086.initial_effect(c)
	c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239086.sprcon)
    e2:SetOperation(c77239086.sprop)
    c:RegisterEffect(e2)

    --cannot trigger
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_F)
    e3:SetCode(EVENT_CHAINING)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c77239086.condition)
    e3:SetTarget(c77239086.target)
    e3:SetOperation(c77239086.activate)
    c:RegisterEffect(e3)

    --atk down
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetValue(c77239086.atkval)
    c:RegisterEffect(e4)
end
----------------------------------------------------------------------------
function c77239086.spcfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(6) and c:IsAbleToGraveAsCost()
end
function c77239086.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239086.spcfilter,tp,LOCATION_MZONE+LOCATION_DECK,0,2,nil)
end
function c77239086.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c77239086.spcfilter,tp,LOCATION_MZONE+LOCATION_DECK,0,2,2,nil)
    Duel.SendtoGrave(g1,REASON_COST)
end
--------------------------------------------------------------------------
function c77239086.condition(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler():IsType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c77239086.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77239086.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
--------------------------------------------------------------------------
function c77239086.vfilter(c)
    return c:IsRace(RACE_SPELLCASTER)
end
function c77239086.atkval(e,c)
	local tp=e:GetHandler():GetControler()
    return Duel.GetMatchingGroupCount(c77239086.vfilter,tp,LOCATION_GRAVE,0,nil)*-500
end


