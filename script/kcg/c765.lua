--Darkness 逆轉命運 (KA)
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
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.desop)
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
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_SZONE,0,1,nil) end 
	Duel.SetChainLimit(s.climit)
end
function s.climit(e,lp,tp)
	return lp==tp
end
function s.ofilter(c)
	return c:IsSetCard(0x316) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsFaceup() and Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local og=Duel.SelectMatchingCard(tp,s.ofilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil):GetFirst()
		if og and not og:IsImmuneToEffect(e) then
			Duel.Overlay(e:GetHandler(),og)
		end
	end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end