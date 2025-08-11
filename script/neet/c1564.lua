--魔装合体 鵺妖霍普雷V(neet)
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	 --set
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(s.ovtg)
	e0:SetOperation(s.ovop)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(s.atkcon)
	e1:SetCost(s.atkcost)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)
end
s.xyz_number=39
s.listed_series={0x107e}
function s.ovfilter(c,sc,tp)
	return c:IsFaceup() and c:IsSetCard(0x107e) and c:GetSequence()<5 and c:IsCanBeXyzMaterial(sc,tp,REASON_EFFECT)
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.ovfilter(chkc,c,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.ovfilter,tp,LOCATION_SZONE,0,1,nil,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,s.ovfilter,tp,LOCATION_SZONE,0,1,1,nil,c,tp)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thfilter(c)
	return c:IsSetCard(0x107e) and c:IsMonster() and c:IsAbleToHand()
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then 
		Duel.Overlay(c,tc) 
		if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil and Duel.IsPhase(PHASE_DAMAGE) and not Duel.IsDamageCalculated() and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetFlagEffect(id)==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetCondition(s.atkcon2)
		e2:SetTarget(s.atktg2)
		e2:SetOperation(s.atkop2)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e2)
	end   
end
function s.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
end
function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToBattle() and not e:GetHandler():IsHasEffect(EFFECT_EXTRA_ATTACK) end
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	--Can make a second attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(3201)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
end