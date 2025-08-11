 --究极蓝眼龙(ZCG)
function c77239149.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetDescription(aux.Stringid(77239149,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_XYZ)
	e1:SetCondition(c77239149.spcon)
	e1:SetOperation(c77239149.spop)
	c:RegisterEffect(e1)

	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(c77239149.efilter)
	c:RegisterEffect(e2)
	
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)	
	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77239149,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c77239149.cost)
	e3:SetTarget(c77239149.sptg)
	e3:SetOperation(c77239149.spop1)
	c:RegisterEffect(e3)	
end
--------------------------------------------------------------------------------------
function c77239149.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c77239149.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return Duel.IsExistingMatchingCard(c77239149.spfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c77239149.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectMatchingCard(tp,c77239149.spfilter,tp,LOCATION_MZONE,0,1,1,nil,nil)
	e:GetHandler():SetMaterial(g1)
	Duel.Overlay(e:GetHandler(),g1)	 
end
--------------------------------------------------------------------------------------
function c77239149.efilter(e,re,rp)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
--------------------------------------------------------------------------------------
function c77239149.filter(c,e,tp)
	return c:IsLevelAbove(8) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239149.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239149.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239149.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c77239149.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77239149.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

