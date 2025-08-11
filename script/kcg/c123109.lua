--Orichalcos Gigas
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2067935,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	  --local e11=Effect.CreateEffect(c)
	  --e11=e1:Clone()
	--e11:SetCondition(s.condition2)
	--e11:SetOperation(s.operation2)
	  --c:RegisterEffect(e11)

	--Skip Draw Phase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_SKIP_DP)
	c:RegisterEffect(e2)

	  if not s.global_check then
	s.global_check=true
	s[0]=0
	s[1]=0
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_DESTROYED)
	ge1:SetOperation(s.checkop)
	Duel.RegisterEffect(ge1,0)
end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	  local a=0
	if e:GetHandler():IsReason(REASON_BATTLE) then a=1 end
	  if e:GetHandler() then
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	--+500 Every time destroyed
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	  e2:SetRange(LOCATION_MZONE)
	  e2:SetCode(EFFECT_UPDATE_ATTACK)
	  e2:SetValue(s[tp]+500)
	  e:GetHandler():RegisterEffect(e2)
	  e:GetHandler():CompleteProcedure()

	  if a==1 then
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN2)
	e:GetHandler():RegisterEffect(e3) 
	end end
end

function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and (Duel.GetCurrentPhase()>PHASE_MAIN1 and Duel.GetCurrentPhase()<PHASE_MAIN2)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	if e:GetHandler() then
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	--+500 Every time destroyed
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	  e2:SetRange(LOCATION_MZONE)
	  e2:SetCode(EFFECT_UPDATE_ATTACK)
	  e2:SetValue(s[tp]+500)
	  e:GetHandler():RegisterEffect(e2)
	  e:GetHandler():CompleteProcedure()

	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_MAIN2)
	e:GetHandler():RegisterEffect(e3) 
	end
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
s[ep]=s[ep]
end
