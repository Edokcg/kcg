--霧の王
local s,id=GetID()
function s.initial_effect(c)
	--decrease tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35950025,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.target)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1828513,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.atkcondition)
	e4:SetTarget(s.atkcost)
	e4:SetOperation(s.atkoperation)
	c:RegisterEffect(e4)

	--tribute check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(s.valcheck)
	c:RegisterEffect(e5)
	--give atk effect only when summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SUMMON_COST)
	e6:SetOperation(s.facechk)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)	  
end

function s.filter(c)
	return c:IsFaceup() and c:IsCode(111215001)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
		or Duel.IsEnvironment(111215001))
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()~=e:GetHandler() and re:GetHandler():IsType(TYPE_MONSTER) then
		Duel.NegateActivation(ev)
	end
end
function s.target(e,c)
	return c~=e:GetHandler() 
end

function s.atkcondition(e,tp,eg,ep,ev,re,r,rp)
	  return e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(96864105)==0 end
	c:RegisterFlagEffect(96864105,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function s.atkoperation(e,tp,eg,ep,ev,re,r,rp)
	   if Duel.GetAttackTarget()==nil then return end
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	   e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	   e1:SetValue(1)
	   e:GetHandler():RegisterEffect(e1)
	   local e2=e1:Clone()
	   Duel.GetAttackTarget():RegisterEffect(e2)
end

function s.valcheck(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local atk=0
	for tc in aux.Next(g) do
		local catk=tc:GetTextAttack()
		atk=atk+(catk>=0 and catk or 0)
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	    e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	end
end
function s.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end