--無限
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	-- e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={511310100,511310104}
s.listed_series={0x316}

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.filter2(c)
	return c:IsFaceup() and c:IsCode(511310100)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetChainLimit(s.climit)
	local c=e:GetHandler()
	local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
	if gdd:GetCount()<1 then return end
	local gd=gdd:Filter(Card.IsFacedown,nil)
	if gd:GetCount()>0 then
		if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,511310104),tp,LOCATION_SZONE,0,1,nil) then
			local left=c:GetSequence()
			local ig=Duel.GetMatchingGroup(s.acinffilter,tp,LOCATION_SZONE,0,nil,left,tp)
			local ic
			if #ig==1 then
				ic=ig:GetFirst()
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				ic=ig:Select(tp,1,1,nil):GetFirst()
			end
			if not ic then return end
			local right=ic:GetSequence()
			if left>right then left,right=right,left end
			local ag=Duel.GetMatchingGroup(s.infacfilter,tp,LOCATION_SZONE,0,nil,left,right)
			if #ag<1 then return end
			s.zero2(c,ag,tp)
		else
			local tc=s.SelectCardByZone(gd,tp,HINTMSG_RESOLVEEFFECT)
			if not tc then return end
			s.zero(c,tc,tp)
		end
	end
end
function s.climit(e,lp,tp)
	return lp==tp
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
function s.infacfilter(c,left,right)
	local seq=c:GetSequence()
	return c:IsFacedown() and left<seq and seq<right 
	-- and c:CheckActivateEffect(false,false,false)
end
function s.acinffilter(c,left,tp)
	local right=c:GetSequence()
	if left>right then left,right=right,left end
	return c:IsFaceup() and c:IsCode(511310104) and Duel.IsExistingMatchingCard(s.infacfilter,tp,LOCATION_SZONE,0,1,nil,left,right)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
	if gdd:GetCount()<1 then return end
	local gd=gdd:Filter(Card.IsFacedown,nil)
	if gd:GetCount()>0 then
		if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,511310104),tp,LOCATION_SZONE,0,1,nil) then
			local left=c:GetSequence()
			local ig=Duel.GetMatchingGroup(s.acinffilter,tp,LOCATION_SZONE,0,nil,left,tp)
			local ic
			if #ig==1 then
				ic=ig:GetFirst()
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				ic=ig:Select(tp,1,1,nil):GetFirst()
			end
			if not ic then return end
			local right=ic:GetSequence()
			if left>right then left,right=right,left end
			local ag=Duel.GetMatchingGroup(s.infacfilter,tp,LOCATION_SZONE,0,nil,left,right)
			if #ag<1 then return end
			s.zero2(c,ag,tp)
		else
			local tc=s.SelectCardByZone(gd,tp,HINTMSG_RESOLVEEFFECT)
			if not tc then return end
			s.zero(c,tc,tp)
		end
	end
end

function s.zero(c,tc,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetLabelObject(tc)
	e1:SetOperation(s.faop)
	Duel.RegisterEffect(e1,tp)
end
function s.faop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	s.sop(e:GetOwner(),tc,Group.CreateGroup(),e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
end
function s.sop(c,tc,g,e,tp,eg,ep,ev,re,r,rp)
	if not tc or tc:IsFaceup() or not tc:IsLocation(LOCATION_SZONE) then return end
	local te=tc:GetActivateEffect()
	if not te then return end
	tc:RegisterFlagEffect(188,RESET_EVENT+RESETS_STANDARD,0,1)
	local tep=tc:GetControler()
	if tc:CheckActivateEffect(false,false,false)~=nil then
		Duel.Activate(te)
		if #g>0 then
			g:KeepAlive()
			local e1=Effect.CreateEffect(tc)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetCountLimit(1)
			e1:SetLabelObject(g)
			e1:SetOperation(s.faop2)
			Duel.RegisterEffect(e1,0)
		end
	else
		Duel.Activate(te)
		if #g>0 then
			s.sop2(c,g,e,tp,eg,ep,ev,re,r,rp)
		end
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
	local c=e:GetOwner()
	while #g>0 do
		local sqtc=g:GetMinGroup(Card.GetSequence):GetFirst()
		g:RemoveCard(sqtc)
		if sqtc:IsLocation(LOCATION_SZONE) then
			s.sop(c,sqtc,g) 
			break 
		end
	end
	g:DeleteGroup()
	e:Reset()
end
function s.sop2(c,g,e,tp,eg,ep,ev,re,r,rp)
	while #g>0 do
		local sqtc=g:GetMinGroup(Card.GetSequence):GetFirst()
		g:RemoveCard(sqtc)
		if sqtc:IsLocation(LOCATION_SZONE) then
			s.sop(c,sqtc,g) 
			break 
		end
	end
end