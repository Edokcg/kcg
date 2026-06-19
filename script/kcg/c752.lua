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

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(s.target)
	e3:SetOperation(s.sop)
	c:RegisterEffect(e3)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition2)
	e2:SetOperation(s.op2)
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
end
function s.climit(e,lp,tp)
	return lp==tp
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end

function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	local c=e:GetHandler()
	return rc:IsSetCard(0x316) and re:IsSpellTrapEffect() and re:IsActiveType(TYPE_CONTINUOUS) 
	and c~=rc and c:GetFlagEffect(id)>0 and rc:IsOnField() and rc:IsControler(tp)
end
function s.ffilter(c)
	return not c:IsSetCard(0x316)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.ffilter,tp,0,LOCATION_DECK,nil):RandomSelect(tp,1)
	g:ForEach(function(tc)
		tc:SetCardData(CARDDATA_PICCODE,186)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_FORBIDDEN)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_SETCODE)
		e3:SetValue(0x316)
		tc:RegisterEffect(e3)
	end)
end