--不死之亡灵艾克佐迪亚(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 c:EnableReviveLimit()
 --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
 --unaffectable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
 --atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetOperation(s.activate) 
	c:RegisterEffect(e4) 
	if not s.global_check then
	s.global_check=true
	s[0]=0
	s[1]=0
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local count=Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)
	  if s[tp]<count then
		count=count-s[tp]
		s[tp]=Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if not e:GetHandler():IsFaceup() then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500*count)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	s[tp]=Duel.GetMatchingGroupCount(s.filter,e:GetHandlerPlayer(),LOCATION_GRAVE,LOCATION_GRAVE,nil)
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*500
end
function s.filter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end