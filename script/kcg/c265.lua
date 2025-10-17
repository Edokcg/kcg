--ZW－獣王獅子武装
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,5,2)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3207)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)

	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(60992364,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(Cost.DetachFromSelf(1))
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)

	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60992364,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
	aux.AddZWEquipLimit(c,nil,function(tc,c,tp) return s.filter(tc) and tc:IsControler(tp) end,s.equipop,e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49678559,0))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.tg)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1157)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.atcon)
	e5:SetOperation(s.atop)
	c:RegisterEffect(e5) 	
end
s.listed_series={0x7f, 0x107e}
	
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.thfilter(c)
	return c:IsSetCard(0x107e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x7f)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	s.equipop(c,e,tp,tc)
end
function s.equipop(c,e,tp,tc)
	if not aux.EquipAndLimitRegister(c,e,tp,tc) then return end
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(3000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function s.afilter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or not c:IsDisabled())
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.afilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.afilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.afilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 and tc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
end

function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local eqc=e:GetHandler():GetEquipTarget()
	return eqc 
	and Duel.GetTurnPlayer()==tp and eqc:CanAttack() and (eqc:IsAttackPos() or eqc:IsHasEffect(EFFECT_DEFENSE_ATTACK)) and eqc:GetAttackedCount()>0
end
function s.atfilter(c)
	return not c:IsHasEffect(EFFECT_CANNOT_BE_BATTLE_TARGET) and not c:IsHasEffect(EFFECT_IGNORE_BATTLE_TARGET)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()	
	if not eqc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)  
	local g=Duel.SelectMatchingCard(tp,s.atfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 or (c:IsHasEffect(EFFECT_DIRECT_ATTACK) and not Duel.SelectYesNo(tp,31)) then 
		Duel.ForceAttack(eqc,g:GetFirst()) 
	else
		Duel.ForceAttack(eqc,0)
	end
end

-- function s.atop3(e,tp,eg,ep,ev,re,r,rp)
-- 	if Duel.GetTurnPlayer()==tp then
-- 	local e1=Effect.CreateEffect(e:GetHandler())
-- 	e1:SetType(EFFECT_TYPE_FIELD)
-- 	e1:SetCode(EFFECT_BP_TWICE)
-- 	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
-- 	e1:SetTargetRange(1,0)
-- 	e1:SetReset(RESET_PHASE+PHASE_END)
-- 	Duel.RegisterEffect(e1,tp) 

-- 	local e5=Effect.CreateEffect(e:GetHandler())
-- 	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
-- 	e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
-- 	e5:SetCountLimit(1)
-- 	e5:SetOperation(s.atop32)
-- 	e5:SetReset(RESET_PHASE+PHASE_END)
-- 	Duel.RegisterEffect(e5,tp) 
-- 	end
-- end
-- function s.atop32(e,tp,eg,ep,ev,re,r,rp)
-- 	--cannot attack
-- 	local e8=Effect.CreateEffect(e:GetHandler())
-- 	e8:SetType(EFFECT_TYPE_FIELD)
-- 	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
-- 	e8:SetTargetRange(LOCATION_MZONE,0)
-- 	e8:SetTarget(s.atktarget)
-- 	  e8:SetReset(RESET_PHASE+PHASE_END)
-- 	Duel.RegisterEffect(e8,tp) 
-- end

-- function s.atop2(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	c:RegisterFlagEffect(265,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,0,2)
-- 	local e1=Effect.CreateEffect(c)
-- 	e1:SetType(EFFECT_TYPE_FIELD)
-- 	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
-- 	e1:SetCode(EFFECT_SKIP_TURN)
-- 	e1:SetTargetRange(0,1)
-- 	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
-- 	Duel.RegisterEffect(e1,tp)
-- 	local e2=Effect.CreateEffect(c)
-- 	e2:SetType(EFFECT_TYPE_FIELD)
-- 	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
-- 	e2:SetTargetRange(1,0)
-- 	e2:SetCode(EFFECT_SKIP_M2)
-- 	e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
-- 	Duel.RegisterEffect(e2,tp)
-- 	local e3=e2:Clone()
-- 	e3:SetCode(EFFECT_CANNOT_EP)
-- 	Duel.RegisterEffect(e3,tp)
-- 	local e5=e3:Clone()
-- 	e5:SetCode(EFFECT_SKIP_DP)
-- 	e5:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
-- 	Duel.RegisterEffect(e5,tp)
-- 	local e6=e5:Clone()
-- 	e6:SetCode(EFFECT_SKIP_SP)
-- 	Duel.RegisterEffect(e6,tp)
-- 	local e7=e5:Clone()
-- 	e7:SetCode(EFFECT_SKIP_M1)
-- 	Duel.RegisterEffect(e7,tp)
-- 	--cannot attack
-- 	local e8=Effect.CreateEffect(c)
-- 	  e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
-- 	e8:SetType(EFFECT_TYPE_FIELD)
-- 	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
-- 	e8:SetRange(LOCATION_SZONE)
-- 	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
-- 	e8:SetTarget(s.atktarget)
-- 	  e8:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
-- 	c:RegisterEffect(e8) 
-- end
-- function s.atktarget(e,c)
-- 	return c~=e:GetHandler():GetEquipTarget()
-- end
