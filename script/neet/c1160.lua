--霸王的逆鳞2（neet）
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.hcon)
	e1:SetTarget(s.het)
	e1:SetOperation(s.hop)
	c:RegisterEffect(e1)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e1:SetLabelObject(sg)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.tcon)
	e3:SetOperation(s.top)
	e3:SetLabelObject(sg)
	c:RegisterEffect(e3)
	
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,id)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCondition(s.spcon)
	e6:SetTarget(s.sptg)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
end
s.listed_names={13331639,703,511009441}
function s.cfilter(c)
	return c:IsFaceup() and (c:IsCode(13331639) or c:IsCode(703) or c:IsCode(511009441))
end
function s.hcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.refilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf8) and c:IsAbleToGrave()
end
function s.het(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.refilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function s.hop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.refilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,99,nil)
	if #g>0 then
		Duel.SendtoGrave(g,POS_FACEUP,REASON_EFFECT)
		local sg=e:GetLabelObject()
		if c:GetFlagEffect(id)==0 then
			sg:Clear()
			c:RegisterFlagEffect(id,RESET_EVENT+0x1680000,0,1)
		end
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			sg:AddCard(tc)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function s.cfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_SYNCHRO))
end
function s.tcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(s.filter,1,nil,e,tp)
end
function s.filter(c,e,tp)
	local g=e:GetLabelObject()
	return c:IsFaceup() and c:IsSummonPlayer(tp) and g:IsExists(s.filter2,1,nil,c,e,tp)
end
function s.filter2(c,eqc,e,tp)
	return c:GetFlagEffect(id)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.top(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local gc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=e:GetLabelObject()
	local gt=eg:Filter(s.filter,nil,e,tp)
	local gtg=gt:GetFirst()
	local tg=Group.CreateGroup()
	local tdg=nil
	for gtg in aux.Next(gt) do
		tdg=g:Filter(s.filter2,nil,gtg,e,tp)
		if #tdg>0 then
			tg:Merge(tdg)
		end
	end
	local sg=tg:Select(tp,1,gc,nil)
	Duel.SetTargetCard(sg)
	Duel.SpecialSummon(sg,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)
end
function s.sfilter(c,eqc,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf8)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g<1 then return end
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end
