--侵食融合(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)	
end
function s.filter1(c,e,tp)
	return c.material and c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil,e,tp,c)
end
function s.filter2(c,e,tp,fc)
	return c:IsControlerCanBeChanged() and c:IsCode(table.unpack(fc.material))
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local fc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectTarget(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil,e,tp,fc):GetFirst()
	if tc then
		tc:ReplaceEffect(1761,RESET_EVENT+RESETS_STANDARD)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end