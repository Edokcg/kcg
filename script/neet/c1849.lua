--银河光子保镖(neet)
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,{id,0},EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	
end
function s.cfilter(c,tp,e)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsControler(tp) and c:IsSetCard({0x7b,0x6b,0x55}) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeEffectTarget(e)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ((rp==1-tp) or (r&REASON_BATTLE)>0) and eg:IsExists(s.cfilter,1,nil,tp,e)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(s.cfilter,nil,tp,e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and #g>=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	e:SetLabelObject(sg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e1:SetValue(tc:GetBaseAttack())
		c:RegisterEffect(e1)
	end
end