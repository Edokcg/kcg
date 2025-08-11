--龙狮之魔
function c77239051.initial_effect(c)
	c:EnableReviveLimit()
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77239051.spcon)
	e1:SetOperation(c77239051.spop)
	c:RegisterEffect(e1)

    --提升攻击力
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c77239051.val)
    c:RegisterEffect(e2)	
	
	--不受陷阱卡效果影响
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(c77239051.efilter)
    c:RegisterEffect(e3)	
end
------------------------------------------------------------------
function c77239051.gfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost()
end
function c77239051.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,2,nil)
		and Duel.IsExistingMatchingCard(c77239051.gfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c77239051.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c77239051.gfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
------------------------------------------------------------------
function c77239051.val(e,c)
    return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_MONSTER)*500
end
-----------------------------------------------------------------
function c77239051.efilter(e,te)
    return te:IsActiveType(TYPE_TRAP)
end

