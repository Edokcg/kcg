--魔法の筒
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(68823957,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(68823957,1))
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_CHAINING)
	e11:SetCondition(s.condition3)
	e11:SetTarget(s.target3)
	e11:SetOperation(s.operation3)
	c:RegisterEffect(e11)
end

function s.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp)
end
function s.usefilter(c)
	return c:IsFaceup() 
	and c:IsRace(RACE_SPELLCASTER)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.usefilter,tp,LOCATION_MZONE,0,1,nil) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return s.filter(chkc,tp) end
	if chk==0 then return tg:IsOnField() and not tg:IsStatus(STATUS_ATTACK_CANCELED)
	  and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	  local tg2=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker() local atked=Duel.GetAttackTarget()
	local tg3=Duel.GetFirstTarget()
	if tg3:IsRelateToEffect(e) and tc:IsOnField() and tc:IsFaceup() and tc:CanAttack() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then 
	  --Duel.HintSelection(Group.FromCards(tg3))  
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_SELF_ATTACK)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e1:SetTargetRange(1,1)
		Duel.RegisterEffect(e1,tp)
		Duel.ChangeAttackTarget(tg3,true)
	--   Duel.ChangeAttackTarget(tg3)
	--   if tg3:GetControler()==tc:GetControler() then 
	--   local e4=Effect.CreateEffect(c)
	--   e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
	--   e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--   e4:SetCode(EVENT_BATTLE_CONFIRM)
	--   e4:SetOperation(function(...) 
	--   if tg3==Duel.GetAttackTarget() then
	--   local e5=Effect.CreateEffect(c)
	--   e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	--   e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	--   e5:SetCode(EVENT_BATTLED)
	--   e5:SetCountLimit(1)
	--   e5:SetOperation(function(...) Duel.ChangeBattleDamage(tp,0) Duel.ChangeBattleDamage(1-tp,0) e5:Reset() end)
	--   e5:SetReset(RESET_PHASE+PHASE_BATTLE)
	--   Duel.RegisterEffect(e5,tp)  
	--   Duel.ChangeBattleDamage(tp,0) Duel.ChangeBattleDamage(1-tp,0)
	--   Duel.CalculateDamage(Duel.GetAttacker(),tg3,false)
	--   end 
	--   e4:Reset() end)
	--   e4:SetCountLimit(1)
	--   e4:SetReset(RESET_PHASE+PHASE_BATTLE)
	--   Duel.RegisterEffect(e4,tp)  
	--   end
	end
end

function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()==0 then return false end
	return g:IsExists(s.filter2,1,nil,tp) 
	and Duel.IsExistingMatchingCard(s.usefilter,tp,LOCATION_MZONE,0,1,nil) 
end
function s.filter2(c,tp) 
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function s.filter3(c,e) 
	return c:IsFaceup() and c:IsRelateToEffect(e) 
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local oe=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	local op=oe:GetOperation()
	local ag,ap,av,are,ar,arp=Duel.GetChainEvent(ev)
	if not g or g:GetCount()==0 then return false end
	local gcount=g:GetCount()
	if not Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then return end
	Duel.ChangeChainOperation(ev,function (...)
	for i=1,gcount do
	  Duel.ClearTargetCard()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	  local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	  Duel.SetTargetCard(g2)
	  op(...)
	  g2:Clear()
	end end)
end
