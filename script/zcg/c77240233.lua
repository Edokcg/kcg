--六芒星之铁甲焰龙 （ZCG）
function c77240233.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,c77240233.filter1,1,c77240233.ffilter,1)
	Fusion.AddContactProc(c,c77240233.contactfil,c77240233.contactop,c77240233.splimit,nil,nil,nil,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77240233.splimit)
	c:RegisterEffect(e1)
--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTarget(c77240233.target)
	e1:SetOperation(c77240233.operation)
	c:RegisterEffect(e1)
	  --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240233,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c77240233.sptg)
	e1:SetOperation(c77240233.spop)
	c:RegisterEffect(e1)
end
function c77240233.filter1(c,fc,sub,sub2,mg,sg)
	return c:IsCode(77239418) or c:IsCode(77239419) or c:IsCode(77239420) or c:IsCode(77239417)
end
function c77240233.ffilter(c,fc,sub,sub2,mg,sg)
	return c:IsCode(77239401) or c:IsCode(77240238) or c:IsCode(77239405) or c:IsCode(77239402) or c:IsCode(77239406) or c:IsCode(77239404) or c:IsCode(77239403)
end
function c77240233.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
end
function c77240233.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
function c77240233.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77240233.desfilter(c)
	return c:IsSetCard(0xa50)
end
function c77240233.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77240233.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c77240233.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240233.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c77240233.desfilter,tp,0,LOCATION_ONFIELD,nil)
	local dg=Duel.Destroy(sg,REASON_EFFECT)
	if dg~=0 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(dg*500)
	c:RegisterEffect(e1)
end
end
function c77240233.filter(c,e,tp)
	return c:IsSetCard(0xa70) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240233.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77240233.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77240233.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77240233.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77240233.spop(e,tp,eg,ep,ev,re,r,rp)
	 local tc=Duel.GetFirstTarget()
	 if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
