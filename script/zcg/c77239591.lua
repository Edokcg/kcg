--邪龙神
function c77239591.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239591.spcon)
    e1:SetOperation(c77239591.spop)
    c:RegisterEffect(e1)
end
--[[function c77239591.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.CheckReleaseGroupEx(tp,Card.IsType,1,nil,TYPE_SPELL)
        and Duel.CheckReleaseGroupEx(tp,Card.IsType,1,nil,TYPE_TRAP)
        and Duel.CheckReleaseGroupEx(tp,Card.IsType,1,nil,TYPE_MONSTER)
end
function c77239591.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,nil,TYPE_SPELL)
    local g2=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,nil,TYPE_TRAP)
    local g3=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.Release(g1,REASON_COST)
end]]

function c77239591.gfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c77239591.gfilter1(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c77239591.gfilter2(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c77239591.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239591.gfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c77239591.gfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
        and Duel.IsExistingMatchingCard(c77239591.gfilter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c77239591.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c77239591.gfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c77239591.gfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c77239591.gfilter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	g1:Merge(g2)
    g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end