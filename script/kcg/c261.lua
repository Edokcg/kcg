--ZW－天風精霊翼
local s,id=GetID()
function s.initial_effect(c)
	--c:SetUniqueOnField(1,0,261)

	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45082499,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	--e1:SetCondition(s.eqcon)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	aux.AddZWEquipLimit(c,nil,function(tc,c,tp) return s.filter(tc) and tc:IsControler(tp) end,s.equipop,e1)

	  local e3=Effect.CreateEffect(c)
	  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	  e3:SetRange(LOCATION_SZONE)
	  e3:SetCategory(CATEGORY_ATKCHANGE)
	  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(s.spcon)
	e3:SetOperation(s.spop)
	  c:RegisterEffect(e3)

	  local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9260791,1))
	  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	  e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	  e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.attcon)
	e4:SetOperation(s.attop)
	  c:RegisterEffect(e4)
end
s.listed_series={0x7f}

function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():CheckUniqueOnField(tp)
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
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
end
function s.equipop(c,e,tp,tc)
	if not aux.EquipAndLimitRegister(c,e,tp,tc) then return end
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(800)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(s.spfilter,nil,tp)>0
end
function s.spfilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsControler(1-tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1600)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
end

function s.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  if e:GetHandler():GetEquipTarget() then
	  Duel.Overlay(e:GetHandler():GetEquipTarget(),c) end
end
