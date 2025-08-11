--超魔导剑士-黑暗帕拉丁(ZCG)
function c77239985.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	if aux.IsKCGScript then
        Fusion.AddProcCode2(c,38033121,46986414,true,true)
        Fusion.AddContactProc(c,c77239985.contactfil,c77239985.contactop,c77239985.splimit)
    else 
        aux.AddFusionProcCode2(c,38033121,46986414,true,true)
        aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD+LOCATION_HAND,0,Duel.SendtoGrave,REASON_COST+REASON_MATERIAL)
    end
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c77239985.actlimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239985,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c77239985.cost)
	e2:SetTarget(c77239985.sptg)
	e2:SetOperation(c77239985.spop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c77239985.val)
	c:RegisterEffect(e3)
end
c77239985.listed_names={38033121,46986414}
function c77239985.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e) and re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function c77239985.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c77239985.sfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239985.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239985.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c77239985.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77239985.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c77239985.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c77239985.val(e,c)
	return Duel.GetMatchingGroupCount(c77239985.filter,0,0x14,0x14,nil)*500
end
function c77239985.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77239985.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
end
function c77239985.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end