--异热同心武器-极限白马装甲(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--Equip itself to an "Utopia" monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.eqcon)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	aux.AddZWEquipLimit(c,s.eqcon,function(tc,c,tp) return s.filter(tc) and tc:IsControler(tp) end,s.equipop,e2)	

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetValue(s.valcon)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(s.atkcon)
	e5:SetCost(s.cost)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)
end
s.listed_series={0x7f}
function s.eqcon(e)
	return e:GetHandler():CheckUniqueOnField(e:GetHandlerPlayer())
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(SET_UTOPIA) and c:IsType(TYPE_XYZ)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) and c:GetOverlayCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not tc:IsRelateToEffect(e) or tc:IsFacedown() or tc:GetControler()~=tp or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	local og=c:GetOverlayGroup()
	Duel.Overlay(tc,og)
	s.equipop(c,e,tp,tc)
end
function s.equipop(c,e,tp,tc)
	if not aux.EquipAndLimitRegister(c,e,tp,tc) then return end
	--Increase the ATK of the equipped monster by 2000
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(3000)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	ec:RemoveOverlayCard(tp,1,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+EVENT_BATTLE_START,0,1)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return e:GetHandler():GetFlagEffect(id)==0 and (Duel.GetAttacker()==ec or Duel.GetAttackTarget()==ec)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(ec:GetDefense())
	ec:RegisterEffect(e1)
end