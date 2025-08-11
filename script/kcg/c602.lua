--i 源數希望皇 Hope (KA)
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x14b),1,2) 
	c:EnableReviveLimit()   

	--cannot special summon
	-- local e0=Effect.CreateEffect(c)
	-- e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e0:SetType(EFFECT_TYPE_SINGLE)
	-- e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- e0:SetValue(s.splimit)
	-- c:RegisterEffect(e0) 

	-- local e1=Effect.CreateEffect(c)
	-- e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	-- e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	-- e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	-- e1:SetRange(LOCATION_MZONE)
	-- e1:SetCondition(s.condition)
	-- e1:SetTarget(s.target)  
	-- e1:SetOperation(s.activate)
	-- c:RegisterEffect(e1)

	-- local e11=Effect.CreateEffect(c)
	-- e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	-- e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	-- e11:SetCode(EVENT_CHAINING)
	-- e11:SetRange(LOCATION_MZONE)
	-- e11:SetCondition(s.condition3)
	-- e11:SetTarget(s.target3)
	-- e11:SetOperation(s.operation3)
	-- c:RegisterEffect(e11)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(86532744,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.rcost)
	e2:SetTarget(s.rtarget)
	e2:SetOperation(s.roperation)
	c:RegisterEffect(e2)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(s.spcondition)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)
	-- local e10=e5:Clone()
	-- e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	-- c:RegisterEffect(e10)
	-- local e98=e5:Clone()
	-- e98:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	-- c:RegisterEffect(e98)
end
s.listed_series={0x14b}
s.listed_names={41418852}

-- function s.splimit(e,se,sp,st)
--  return se:GetHandler():IsCode(593) 
-- end

-- function s.filter(c,tp)
--  return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp)
-- end
-- function s.condition(e,tp,eg,ep,ev,re,r,rp)
--  return tp~=Duel.GetTurnPlayer() 
-- end
-- function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
--  local tg=Duel.GetAttacker()
--  if chkc then return s.filter(chkc,tp) end
--  if chk==0 then return tg:IsOnField() and tg:CanAttack() 
--	   and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
--	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
--	   local tg2=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
-- end
-- function s.activate(e,tp,eg,ep,ev,re,r,rp)
--  local tc=Duel.GetAttacker()
--	   local tg3=Duel.GetFirstTarget()
--  if tg3:IsRelateToEffect(e) and tc:IsFaceup() and tc:CanAttack() then	
--	   Duel.ChangeAttackTarget(tg3)
--  end
-- end

-- function s.condition3(e,tp,eg,ep,ev,re,r,rp)
--  if rp==tp then return false end
--  if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
--  local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
--  return tg and tg:FilterCount(s.filter2,nil,tp)>0
-- end
-- function s.filter2(c,tp) 
--  return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
-- end
-- function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
--  if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
--  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
--  local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
--			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
--  Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,g:GetCount(),nil)
-- end
-- function s.filter3(c,e) 
--  return c:IsFaceup() and c:IsRelateToEffect(e) 
-- end
-- function s.operation3(e,tp,eg,ep,ev,re,r,rp)
--	   local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.filter3,nil,e)
--	   if g:GetCount()>0 then
--	   Duel.ChangeTargetCard(ev,g) end
-- end

function s.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>1 end
	Duel.SetLP(tp,1)
end
function s.rtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg2=Duel.GetMatchingGroup(s.ovfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	  local dam=0
	  local tc=sg2:GetFirst()
	  while tc do
	  local atk=tc:GetAttack()
	  dam=dam+atk
	  tc=sg2:GetNext() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function s.ovfilter2(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function s.roperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)<1 then return end
	local sg2=Duel.GetOperatedGroup()
	local dam=0
	local tc=sg2:GetFirst()
	while tc do
		local atk=tc:GetPreviousAttackOnField()
		dam=dam+atk
		tc=sg2:GetNext() 
	end
	Duel.BreakEffect()
	Duel.Damage(1-tp,dam,REASON_EFFECT)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10449150,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1)
	e4:SetCondition(s.rspcon)
	e4:SetTarget(s.rsptg)
	e4:SetOperation(s.rspop)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	else
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	end
	c:RegisterEffect(e4)	
end
function s.rspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.rsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.rspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end
end

function s.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function s.damfilter(c)
	return c:IsFaceup() and c:IsCode(41418852)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if g~=nil and s.damfilter(g) then	
	g:RegisterFlagEffect(602,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) end
end

