--Necro Chaos
function c13735.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13735.target)
	e1:SetOperation(c13735.activate)
	c:RegisterEffect(e1)

	--register
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetDescription(aux.Stringid(511000687,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c13735.regop)
	Duel.RegisterEffect(e3,0)
end

function c13735.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetFlagEffect(13735)~=0
		and Duel.IsExistingMatchingCard(c13735.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank(),c)
end
function c13735.filter2(c,e,tp,rk,tc)
	return c:GetRank()==rk and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
		and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
end
function c13735.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c13735.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c13735.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c13735.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c13735.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	  if tc==nil then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13735.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank(),tc)
	local tg=g:GetFirst()
	if tg and Duel.SpecialSummonStep(tg,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tg:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
		tg:CompleteProcedure()
	end
end

function c13735.regfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and not c:IsReason(REASON_RETURN) and c:IsType(TYPE_XYZ) and c:GetFlagEffect(13735)==0
end
function c13735.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c13735.regfilter,nil,e:GetHandler():GetControler())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(13735,RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
	end
end
