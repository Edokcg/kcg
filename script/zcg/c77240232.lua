--六芒星之铁甲飞龙 （ZCG）
function c77240232.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,c77240232.filter,1,c77240232.ffilter,1)
	Fusion.AddContactProc(c,c77240232.contactfil,c77240232.contactop,c77240232.splimit,nil,nil,nil,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77240232.splimit)
	c:RegisterEffect(e1)
--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTarget(c77240232.target)
	e2:SetOperation(c77240232.operation)
	c:RegisterEffect(e2)
 --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240232,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c77240232.target2)
	e3:SetOperation(c77240232.operation2)
	c:RegisterEffect(e3)
end
function c77240232.filter(c,fc,sub,sub2,mg,sg)
	return c:IsCode(77239418) or c:IsCode(77239419) or c:IsCode(77239420) or c:IsCode(77239417)
end
function c77240232.ffilter(c,fc,sub,sub2,mg,sg)
	return c:IsCode(77239401) or c:IsCode(77240238) or c:IsCode(77239405) or c:IsCode(77239402) or c:IsCode(77239406) or c:IsCode(77239404) or c:IsCode(77239403)
end
function c77240232.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
end
function c77240232.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
function c77240232.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77240232.desfilter(c)
	return c:IsSetCard(0xa50)
end
function c77240232.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77240232.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c77240232.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240232.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c77240232.desfilter,tp,0,LOCATION_ONFIELD,nil)
	local dg=Duel.Destroy(sg,REASON_EFFECT)
	if dg~=0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(dg)
	c:RegisterEffect(e1)
end
end
function c77240232.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c,PLAYER_NONE,true)
end
function c77240232.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetMaterial()
	if chk==0 then
		local ct=g:GetCount()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetHandler():GetSequence()<5 then ft=ft+1 end
		return ct>0 and ft>=ct and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
			and g:FilterCount(c77240232.mgfilter,nil,e,tp,e:GetHandler(),g)==ct
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c77240232.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=e:GetHandler():GetMaterial()
	local ct=g:GetCount()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and g:FilterCount(c77240232.mgfilter,nil,e,tp,e:GetHandler(),g)==ct then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end