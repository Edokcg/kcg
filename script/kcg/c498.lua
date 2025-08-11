--WW－クリスタル・ベル
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,497,s.ffilter)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(s.effcon)
	e0:SetOperation(s.spsumsuc)
	c:RegisterEffect(e0)

	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(s.cptg)
	e1:SetOperation(s.cpop)
	c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(s.fusfilter)
	c:RegisterEffect(e5)
end
s.miracle_synchro_fusion=true
s.listed_names={497}

function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and re and re:GetHandler():IsCode(497)
end
function s.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local ag=g:Remove(Card.IsCode,c,497)
	if #ag~=1 then return end
	local tc=ag:GetFirst()
	if not tc:IsType(TYPE_SYNCHRO) or tc:GetOriginalLevel()>11 then return end
	c:SetCardData(CARDDATA_SETCODE, {tc:GetOriginalSetCard()})
	c:SetCardData(CARDDATA_ATTRIBUTE, tc:GetOriginalAttribute())
	c:SetCardData(CARDDATA_RACE, tc:GetOriginalRace())
	c:SetCardData(CARDDATA_ATTACK, tc:GetTextAttack()+400)
	c:SetCardData(CARDDATA_DEFENSE, tc:GetTextDefense()+400)
	c:SetCardData(CARDDATA_LEVEL, tc:GetOriginalLevel()+1)
end

function s.ffilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_SYNCHRO,fc,sumtype,tp) and c:GetOriginalLevel()<12
end

function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,TYPE_MONSTER)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY)
end
function s.spfilter1(c,e,tp)
	local setcard={c:GetSetCard()}
	if not setcard then return false end
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsExistingTarget(s.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function s.spfilter2(c,e,tp,tc)
	local setcard={c:GetSetCard()}
	if not setcard then return false end
	local setcard2={tc:GetSetCard()}
	for _,v in ipairs(setcard) do
		for _,u in ipairs(setcard2) do
			if v==u then return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
		end
	end
	return false
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsExistingTarget(s.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,s.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g1<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,s.spfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<#g or (#g>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then return end
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.fusfilter(e,se,sp,st)
	return se:GetHandler():IsCode(497)
end
