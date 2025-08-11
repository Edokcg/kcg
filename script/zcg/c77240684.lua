--不死之苏生(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xa250) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,2,2,nil,e,tp)
		local tc=g:GetFirst()
		local fid=e:GetHandler():GetFieldID()
		while tc do
			if aux.NecroValleyFilter()(tc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetLabel(fid)
				e1:SetLabelObject(tc)
				e1:SetCondition(s.tgcon)
				e1:SetOperation(s.tgop)
				Duel.RegisterEffect(e1,tp)
			end
			tc=g:GetNext()
		end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
