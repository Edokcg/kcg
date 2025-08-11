--水生物 精灵(neet)
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),1,1,Synchro.NonTunerEx(Card.IsRace,RACE_AQUA),1,99)
	c:EnableReviveLimit() 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.ltg)
	e2:SetOperation(s.lop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.desreptg)
	e3:SetOperation(s.desrepop)
	c:RegisterEffect(e3)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetSequence()>4
end
function s.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c,0x60)>0
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.op(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if e:GetHandler():GetSequence()>4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		if Duel.MoveSequence(e:GetHandler(),math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0),2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
			end
		end
	end
end
function s.lkfilter(c)
	return c:IsFaceup() and c:IsLinkMonster()
end
function s.desfilter(c,g)
	return g:IsContains(c)
end
function s.filter(c,ec)
	return c:IsLinkMonster() and c:GetLinkedGroup():IsContains(ec)
end
function s.ltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Group.CreateGroup()
	local lg=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do
		tg:Merge(tc:GetLinkedGroup())
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.desfilter(chkc,tg) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tg) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local g1=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tg)
	local lmt=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
	local g2=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lmt)
	local tc=g2:GetFirst()
	local lm=shuishenwufun(tc,lmt,tp)
	e:SetLabel(lm)
end
function s.lop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lm=e:GetLabel()
	local lm2=0
	if tc:IsLinkMarker(0x1) then lm2=lm2+0x1 end
	if tc:IsLinkMarker(0x2) then lm2=lm2+0x2 end
	if tc:IsLinkMarker(0x4) then lm2=lm2+0x4 end
	if tc:IsLinkMarker(0x8) then lm2=lm2+0x8 end
	if tc:IsLinkMarker(0x20) then lm2=lm2+0x20 end
	if tc:IsLinkMarker(0x40) then lm2=lm2+0x40 end
	if tc:IsLinkMarker(0x80) then lm2=lm2+0x80 end
	if tc:IsLinkMarker(0x100) then lm2=lm2+0x100 end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and lm~=0 then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetRange(LOCATION_MZONE)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetCode(EFFECT_CHANGE_LINKMARKER)
		e0:SetValue(lm+lm2)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2)) 
	else
	   Debug.ShowHint("水生物 精灵②效果暂未完善") 
	end
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsAbleToExtra() end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else return false end
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end

function shuishenwufun(tc1,tc2,tp)
	local seq1=tc1:GetSequence()
	local seq2=tc2:GetSequence()
	local lm=0x0
	if seq1==5 and seq2==0 and Duel.CheckLocation(tp,LOCATION_MZONE,2) then lm=0x2 end
	if seq1==5 and seq2==1 then
		if Duel.CheckLocation(tp,LOCATION_MZONE,0) then lm=lm+0x1 end
		if Duel.CheckLocation(tp,LOCATION_MZONE,2) then lm=lm+0x4 end
	end
	if seq1==5 and seq2==2 and Duel.CheckLocation(tp,LOCATION_MZONE,1) then lm=0x2 end
	if seq1==6 and seq2==2 and Duel.CheckLocation(tp,LOCATION_MZONE,3) then lm=0x2 end
	if seq1==6 and seq2==3 then 
		if Duel.CheckLocation(tp,LOCATION_MZONE,2) then lm=lm+0x1 end
		if Duel.CheckLocation(tp,LOCATION_MZONE,4) then lm=lm+0x4 end
	end
	if seq1==6 and seq2==4 and Duel.CheckLocation(tp,LOCATION_MZONE,3) then lm=0x2 end

	if seq1==0 and seq2==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1) then lm=0x20 end
	if seq1==0 and seq2==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5) then lm=0x100 end

	if seq1==2 and seq2==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5) then lm=0x40 end
	if seq1==2 and seq2==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6) then lm=0x100 end

	if seq1==2 and seq2==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1) then lm=0x8 end
	if seq1==2 and seq2==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3) then lm=0x20 end

	if seq1==4 and seq2==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3) then lm=0x8 end 
	if seq1==4 and seq2==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6) then lm=0x40 end
	return lm
end