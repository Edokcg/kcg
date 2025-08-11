--末日残影 (KA)
function c573.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c573.tg)
	e1:SetOperation(c573.op)
	c:RegisterEffect(e1)	
end

function c573.filter(c,e,tp)
	return c:IsSetCard(0x900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c573.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 
		and Duel.IsExistingMatchingCard(c573.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,tp,LOCATION_GRAVE)
end
function c573.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c573.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	if g:GetCount()>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local de=Effect.CreateEffect(e:GetHandler())
	    de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	    de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	    de:SetRange(LOCATION_MZONE)
	    de:SetCode(EVENT_PHASE+PHASE_END)
	    de:SetCountLimit(1)
	    de:SetOperation(c573.desop)
	    de:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	    tc:RegisterEffect(de,true)
		Duel.SpecialSummonComplete()
		tc=g:GetNext()
		end
	end
end
function c573.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end