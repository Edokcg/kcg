--i 源數希望皇 Hope (KA)
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x14b),2,3,s.ovfilter,aux.Stringid(603,0))  
	c:EnableReviveLimit()

	-- local e1=Effect.CreateEffect(c)
	-- e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	-- e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	-- e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	-- e1:SetRange(LOCATION_MZONE)
	-- e1:SetCondition(s.condition)
	-- e1:SetTarget(s.target)  
	-- e1:SetOperation(s.activate)
	--c:RegisterEffect(e1)

	-- local e11=Effect.CreateEffect(c)
	-- e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	-- e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	-- e11:SetCode(EVENT_CHAINING)
	-- e11:SetRange(LOCATION_MZONE)
	-- e11:SetCondition(s.condition3)
	-- e11:SetTarget(s.target3)
	-- e11:SetOperation(s.operation3)
	--c:RegisterEffect(e11)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(86532744,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.rcondition)
	e2:SetTarget(s.rtarget)
	e2:SetOperation(s.roperation)
	c:RegisterEffect(e2)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(s.spcondition)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)

	-- local e6=Effect.CreateEffect(c)
	-- e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	-- e6:SetCode(EVENT_PHASE+PHASE_END)
	-- e6:SetCountLimit(1)
	-- e6:SetRange(LOCATION_MZONE)
	-- e6:SetOperation(s.desop)
	--c:RegisterEffect(e6)
end
s.listed_series={0x14b}
s.listed_names={41418852,602}

function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(602)
end

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

function s.rcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)==1
end
function s.rtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.ovfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local sg2=Duel.GetMatchingGroup(s.ovfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		ft=1
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg2,math.min(ft,sg2:GetCount()),0,0)
end
function s.ovfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_XYZ, tp, false, false, POS_FACEUP) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x14b)
end
function s.roperation(e,tp,eg,ep,ev,re,r,rp)
	local sg2=Duel.GetMatchingGroup(s.ovfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<1 or sg2:GetCount()<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		ft=1
	end
	local g=Duel.SelectMatchingCard(tp,s.ovfilter2,tp,LOCATION_REMOVED,0,1,math.min(ft,sg2:GetCount()),nil,e,tp)
	if Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local g2=Duel.GetOperatedGroup()
		Duel.Recover(tp,g2:GetSum(Card.GetAttack),REASON_EFFECT)
	end
end

-- function s.desop(e,tp,eg,ep,ev,re,r,rp)
--  local c=e:GetHandler()
--			 if c:GetFlagEffect(603)==0 then
--  c:RegisterFlagEffect(603,RESET_EVENT+0x1fe0000,0,1)
--  c:SetTurnCounter(0) end
--  local ct=c:GetTurnCounter()
--  ct=ct+1
--  c:SetTurnCounter(ct)
--  if ct==6 then
--  local WIN_REASON_CiNo100=0x52
--  Duel.Win(tp,WIN_REASON_CiNo100)
--  end
-- end

-- function s.atkop(e,tp,eg,ep,ev,re,r,rp)
--	 e:GetHandler():RegisterFlagEffect(592,RESET_EVENT+0x1fe0000,0,1)
-- end

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

