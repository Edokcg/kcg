--炎王兽 辛玛（neet）
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
--SpecialSummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,id)
	e6:SetCondition(s.erascon)
	e6:SetTarget(s.sptg)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
end
s.listed_series={0x81}
function s.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x81) and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsPreviousLocation(LOCATION_MZONE) 
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.cfilter,1,nil,tp) and (r&REASON_DESTROY)~=0
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end
function s.erascon(e)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x81) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		   g:KeepAlive()
		   local fid=e:GetHandler():GetFieldID()
		   g:GetFirst():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)										 
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		   e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		   e1:SetCode(EVENT_PHASE+PHASE_END)
		   e1:SetCountLimit(1)
		   e1:SetLabel(fid)
		   e1:SetLabelObject(g)
		   e1:SetOperation(s.desop)
		   e1:SetReset(RESET_PHASE+PHASE_END)
		   Duel.RegisterEffect(e1,tp)
		end
	end
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.Destroy(g,REASON_EFFECT)
end