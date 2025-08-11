--虚無
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_CANNOT_INACTIVATE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.filter2(c)
	return c:IsFaceup() and c:IsCode(511310100) and not c:IsDisabled()
end
function s.filter(c,code)
	return c:IsFaceup() and c:IsCode(code) and not c:IsDisabled()
end
function s.filter3(c,seq1,seq2)
	return c:IsFacedown() and c:GetSequence()<seq1 and c:GetSequence()>seq2
end

function s.getflag(g,tp)
    local flag = 0
    for c in aux.Next(g) do
        flag = flag|((1<<c:GetSequence())<<(8+(16*c:GetControler())))
    end
    if tp~=0 then
        flag=((flag<<16)&0xffff)|((flag>>16)&0xffff)
    end
    return ~flag
end
function s.SelectCardByZone(g,tp,hint)
	if hint then Duel.Hint(HINT_SELECTMSG,tp,hint) end
	local sel=Duel.SelectFieldZone(tp,1,LOCATION_SZONE,0,s.getflag(g,tp))>>8
	local seq=math.log(sel,2)
	local c=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
	return c
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
	if gdd:GetCount()<1 then return end
	local gd=gdd:Filter(Card.IsFacedown,c)
	if gd:GetCount()>0 then
		local tc=s.SelectCardByZone(gd,tp,HINTMSG_RESOLVEEFFECT)
		if not tc or Duel.ChangePosition(tc,POS_FACEUP)<1 then return end
		if tc:IsCode(511310105) then
			local fseq=tc:GetSequence()
			local seq=e:GetHandler():GetSequence()
			if fseq>seq then local s=seq seq=fseq fseq=s end
			local sqc=gd:Filter(s.filter3,c,seq,fseq)
			if Duel.ChangePosition(sqc,POS_FACEUP)<1 then return end
			sqc=Duel.GetOperatedGroup()
			if #sqc<1 then return end
			local sqtc=sqc:GetMinGroup(Card.GetSequence):GetFirst()
			local fcode=sqtc:GetOriginalCode()
			for sqtc2 in aux.Next(sqc) do
				sqtc2:RegisterFlagEffect(fcode,RESET_EVENT+0x1fe0000+RESET_CHAIN+RESET_PHASE+PHASE_END,0,1)
			end
			while sqc:GetCount()>0 do
				local sqtc2=sqc:GetMinGroup(Card.GetSequence):GetFirst()
				s.zero(sqtc2,tp)
				if not sqtc2:IsType(TYPE_CONTINUOUS) and not sqtc2:IsHasEffect(EFFECT_REMAIN_FIELD) then Duel.SendtoGrave(sqtc2,REASON_RULE) end
				sqc:RemoveCard(sqtc2) 
			end				
		else
			s.zero(tc,tp)
			if not tc:IsType(TYPE_CONTINUOUS) and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then Duel.SendtoGrave(tc,REASON_RULE) end
		end
	end
end

function s.zero(tc,tep)
	local te=tc:GetActivateEffect()
	if te==nil or tc:CheckActivateEffect(false,false,false)==nil then return end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	Duel.ClearTargetCard()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
	tc:CreateEffectRelation(te)
	local gg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if gg then  
		local etc=gg:GetFirst()	
		while etc do
			etc:CreateEffectRelation(te)
			etc=gg:GetNext()
		end
	end						
	if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)					
	if gg then  
		local etc=gg:GetFirst()												 
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=gg:GetNext()
		end
	end 
end