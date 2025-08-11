--グランエルＡ
local s, id = GetID()
function s.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.sdcon2)
	c:RegisterEffect(e1)

	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000061,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.eqcon)
	e4:SetTarget(s.eqtg)
	e4:SetOperation(s.eqop)
	c:RegisterEffect(e4)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(LOCATION_SZONE,0)
	e11:SetCode(EFFECT_EQUIP_MONSTER)
	e11:SetCondition(s.eecon)
	e11:SetTarget(s.eefilter)
	c:RegisterEffect(e11)   
	local e12=e11:Clone()
	e12:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e12)		   
end
s.listed_series={0x3013}

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3013)
end
function s.sdcon2(e)
	return not Duel.IsExistingMatchingCard(s.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function s.eecon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
	and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.eefilter(e,c)
	return c:IsFaceup() and c:GetEquipTarget() and c:IsOriginalType(TYPE_MONSTER) and c:GetEquipTarget():IsSetCard(0x3013)
end

function s.spcon30(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetFlagEffect(164)==0
	and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetCurrentChain()==0
end
function s.spfilter(c,e,tp)
	if c:GetEquipTarget()~=nil then
	return c:IsFaceup() and c:GetEquipTarget():IsSetCard(0x3013) and c:IsOriginalType(TYPE_MONSTER) end   
end
function s.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	e:GetHandler():RegisterFlagEffect(164,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
end
function s.piercetg(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc2=Duel.GetFirstTarget()
	if tc2 and tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
		  --immune
		  local e121=Effect.CreateEffect(c)
		  e121:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		  e121:SetType(EFFECT_TYPE_SINGLE)
		  e121:SetRange(LOCATION_MZONE)
		  e121:SetCode(EFFECT_IMMUNE_EFFECT)
		  e121:SetValue(s.efilter)
		  e121:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		  c:RegisterEffect(e121)
		  local e5=e121:Clone()
		  e5:SetCode(EFFECT_CHANGE_CODE)
		  e5:SetValue(tc2:GetCode())
		  c:RegisterEffect(e5)
		  local e6=e121:Clone()
		  e6:SetCode(EFFECT_SET_BASE_ATTACK)
		  e6:SetValue(tc2:GetBaseAttack())
		  c:RegisterEffect(e6)
		  local e7=e121:Clone()
		  e7:SetCode(EFFECT_SET_BASE_DEFENSE)
		  e7:SetValue(tc2:GetBaseDefense())
		  c:RegisterEffect(e7)
		  local e8=e121:Clone()
		  e8:SetCode(EFFECT_CHANGE_TYPE)
		  e8:SetValue(tc2:GetOriginalType())
		  c:RegisterEffect(e8)
		  local e3=Effect.CreateEffect(c)
		  e3:SetType(EFFECT_TYPE_SINGLE)
		  --e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		  e3:SetCode(EFFECT_PIERCE)
			--e3:SetRange(LOCATION_MZONE)
		  e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		  c:RegisterEffect(e3) 
		  local e4=Effect.CreateEffect(c)
		  e4:SetType(EFFECT_TYPE_SINGLE)
		  e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		  e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		  c:RegisterEffect(e4) 
	  end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	  return eg:GetFirst():IsType(TYPE_SYNCHRO) and eg:GetFirst():IsAbleToChangeControler() and eg:GetFirst():GetBattleTarget():IsSetCard(0x3013) and eg:GetFirst():GetBattleTarget():IsControler(tp)
end
function s.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and eg:GetFirst():IsType(TYPE_SYNCHRO) and eg:GetFirst():IsAbleToChangeControler() 
			and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
end
function s.eqlimit(e,c)
	  local tc2=e:GetLabelObject()
	  return c==tc2 and not c:IsDisabled()
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)   
	local tc2=g:GetFirst()
	local tc=eg:GetFirst()
	if tc:IsFaceup() then
		if tc2~=nil and tc2:IsFaceup() and not tc2:IsImmuneToEffect(e) then
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end
			if not Duel.Equip(tp,tc,tc2,false) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(s.eqlimit)
			e1:SetLabelObject(tc2)
			tc:RegisterEffect(e1)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
