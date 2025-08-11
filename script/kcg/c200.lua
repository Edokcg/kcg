--Sin パラドクスギア
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetCondition(s.spcon2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end
s.listed_series={0x23}
s.listed_names={74509280,27564031}

function s.repfilter(c)
	return c:IsCode(27564031) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,r,rp)
	return Duel.IsExistingMatchingCard(s.repfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.spfilter(c,e,tp,chk)
	return c:IsCode(74509280) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and (not chk or Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,c))
end
function s.thfilter(c)
	return c:IsSetCard(0x23) and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler(c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local ag=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #ag>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(ag,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,ag)
			end
		end
	end
end

function s.spfilter2(c)
	return c:IsSetCard(0x23) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.spfilter2,nil)
	return #g==1
end
function s.fusfilter(c,e,tp,fe,eg)
	local g=eg:Filter(s.spfilter2,nil):GetFirst()
	if not g then return false end
	local sg=g:GetMaterial()
	if #sg<1 then return false end
	local sg2=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #sg~=#sg2 then return false end
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and c:CheckFusionMaterial(sg,nil,sg)
		and Duel.GetLocationCountFromEx(tp,fe,nil,c)>0
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e,eg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fc=Duel.SelectMatchingCard(tp,s.fusfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e,eg):GetFirst()
	if not fc then return end
	local g=eg:Filter(s.spfilter2,nil):GetFirst()
	if not g then return false end
	local sg=g:GetMaterial()
	if #sg<1 then return end
	local sg2=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #sg~=#sg2 then return end
	fc:SetMaterial(sg)
	Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	fc:CompleteProcedure()
end