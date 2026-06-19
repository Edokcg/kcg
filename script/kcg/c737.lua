local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.target)
	-- e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
s.listed_series={0x316}

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
function s.filter(c)
	return c:IsSetCard(0x316) and c:IsFaceup() and c:IsSpellTrap() and c:IsType(TYPE_CONTINUOUS)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_SZONE,0,1,nil) end
	local gdd=Duel.GetMatchingGroup(s.filter,tp,LOCATION_SZONE,0,nil)
	local tc=s.SelectCardByZone(gdd,tp,HINTMSG_FACEUP)
	Duel.SetTargetCard(tc)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local zone=1<<tc:GetSequence()
		Duel.Overlay(c,tc)
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,zone)
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetChainLimit(s.climit)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local gdd=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_SZONE,0,nil)
	for tc in aux.Next(gdd) do
		local xyz=tc:GetOverlayGroup():Filter(s.filter3,nil)
		g:Merge(xyz)
	end
	if #g>0 then s.zero2(c,g,tp) end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.climit(e,lp,tp)
	return lp==tp
end
function s.filter2(c)
	return c:IsSetCard(0x316) and c:IsFaceup() and c:IsSpellTrap() and c:IsType(TYPE_CONTINUOUS)
	and c:GetFlagEffect(c:GetOriginalCode())>0
end
function s.filter3(c)
	return c:IsSetCard(0x316) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local gdd=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_SZONE,0,nil)
	for tc in aux.Next(gdd) do
		local xyz=tc:GetOverlayGroup():Filter(s.filter3,nil)
		g:Merge(xyz)
	end
	if #g>0 then s.zero2(c,g,tp) end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end

function s.zero(c,tc,g,e,tp,eg,ep,ev,re,r,rp)
	local te=tc:GetActivateEffect()
	if not te then return end
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,false)
	if te~=nil then
		-- c:SetStatus(STATUS_CHAINING,true)
		local cost=te:GetCost()
		Duel.ClearTargetCard()
		local target=te:GetTarget()
		local operation=te:GetOperation()
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
		if target then target(e,tp,eg,ep,ev,re,r,rp,1) end
		c:CreateEffectRelation(te)
		local gg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if gg then
			local etc=gg:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=gg:GetNext()
			end
		end
		Duel.RaiseEvent(c,EVENT_PRECHAINING,e,0,tp,tp,0)
		Duel.RaiseEvent(c,EVENT_CHAINING,e,0,tp,tp,0)
		Duel.RaiseEvent(Group.CreateGroup(),EVENT_CHAIN_ACTIVATING,e,0,tp,tp,0)
		c:SetStatus(STATUS_CHAINING,false)
		Duel.RaiseEvent(Group.CreateGroup(),EVENT_CHAIN_SOLVING,e,0,tp,tp,0)
		-- Duel.BreakEffect()
		if operation then operation(e,tp,eg,ep,ev,re,r,rp) end
		-- Duel.RaiseEvent(Group.CreateGroup(),EVENT_CHAIN_SOLVED,e,0,tp,tp,0)
		c:ReleaseEffectRelation(te)
		if gg then  
			local etc=gg:GetFirst()								
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=gg:GetNext()
			end
		end
		-- Duel.RaiseEvent(Group.CreateGroup(),EVENT_CHAIN_END,e,0,0,0,0)
	end
	if #g>0 then
		s.sop2(c,g,e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.zero2(c,g,tp)
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetLabelObject(g)
	e1:SetOperation(s.faop2)
	Duel.RegisterEffect(e1,tp)
end
function s.faop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g<1 then
		g:DeleteGroup()
		e:Reset()
		return
	end
	local c=e:GetOwner()
	local gdd=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_SZONE,0,nil)
	while #gdd>0 do
		local chk=false
		local sqtc=gdd:GetMinGroup(Card.GetSequence):GetFirst()
		gdd:RemoveCard(sqtc)
		local xyz=sqtc:GetOverlayGroup():Filter(s.filter3,nil)
		while #xyz>0 do
			local sqtc2=xyz:GetMinGroup(Card.GetSequence):GetFirst()
			xyz:RemoveCard(sqtc2)
			if g:IsContains(sqtc2) then
				g:RemoveCard(sqtc2)
				s.zero(c,sqtc2,g,e,tp,eg,ep,ev,re,r,rp)
				chk=true
				break
			end
		end
		if chk then break end
	end
	g:DeleteGroup()
	e:Reset()
end
function s.sop2(c,g,e,tp,eg,ep,ev,re,r,rp)
	local gdd=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_SZONE,0,nil)
	while #gdd>0 do
		local chk=false
		local sqtc=gdd:GetMinGroup(Card.GetSequence):GetFirst()
		gdd:RemoveCard(sqtc)
		local xyz=sqtc:GetOverlayGroup():Filter(s.filter3,nil)
		while #xyz>0 do
			local sqtc2=xyz:GetMinGroup(Card.GetSequence):GetFirst()
			xyz:RemoveCard(sqtc2)
			if g:IsContains(sqtc2) then
				g:RemoveCard(sqtc2)
				s.zero(c,sqtc2,g,e,tp,eg,ep,ev,re,r,rp)
				chk=true
				break
			end
		end
		if chk then break end
	end
end