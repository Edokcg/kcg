--邪神 进化之化身(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)   
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(s.spcon2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)	
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.immval)
	c:RegisterEffect(e4)
	--cannot act spelltrap
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(s.aclimit)
	c:RegisterEffect(e5) 
	--atk check
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(21208154)
	c:RegisterEffect(e6)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_SET_ATTACK_FINAL)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(s.aval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e8:SetValue(s.dval)
	c:RegisterEffect(e8)
	--
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_CHANGE_CODE)
	e9:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e9:SetValue(21208154)
	c:RegisterEffect(e9)
end
s.listed_names={21208154}
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp)
	return aux.SelectUnselectGroup(rg,e,tp,4,4,aux.ChkfMMZ(1),0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp)
	local mg=aux.SelectUnselectGroup(rg,e,tp,4,4,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #mg==4 then
		mg:KeepAlive()
		e:SetLabelObject(mg)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function s.rfilter(c,tp)
	return c:IsCode(21208154) and (c:IsControler(tp) or c:IsFaceup())
end
function s.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(s.rfilter,nil,tp)
	return aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(s.rfilter,nil,tp)
	local mg=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #mg==1 then
		mg:KeepAlive()
		e:SetLabelObject(mg)
		return true
	end
	return false
end
function s.immval(e,re)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c) and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL|TYPE_TRAP)
end
function s.filter(c)
	return c:IsFaceup() and not c:IsHasEffect(21208154)
end
function s.aval(e,c)
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then
		return 1000
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val+1000
	end
end
function s.dval(e,c)
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then
		return 1000
	else
		local tg,val=g:GetMaxGroup(Card.GetDefense)
		return val+1000
	end
end