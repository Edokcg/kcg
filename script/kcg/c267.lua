--ZW－不死鳥弩弓
local s,id=GetID()
function s.initial_effect(c)
	--c:SetUniqueOnField(1,0,87008374)

	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87008374,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	--e1:SetCondition(s.eqcon)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	aux.AddZWEquipLimit(c,nil,function(tc,c,tp) return s.filter(tc) and tc:IsControler(tp) end,s.equipop,e1)

	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31764700,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	e3:SetTarget(s.rdtg)
	e3:SetOperation(s.rdop)
	c:RegisterEffect(e3)
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
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
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
	e1:SetValue(1100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

function s.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipTarget() and e:GetHandler():GetEquipTarget():GetBattleTarget()~=nil and e:GetHandler():GetEquipTarget():GetBattleTarget():IsOnField() and not e:GetHandler():GetEquipTarget():GetBattleTarget():IsStatus(STATUS_BATTLE_DESTROYED) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	  local atker=e:GetHandler():GetEquipTarget():GetBattleTarget()
	  Duel.SetOperationInfo(0,CATEGORY_DESTROY,atker,1,0,0) 
	  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000) 
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	  if e:GetHandler():GetEquipTarget()==nil then return end
	  local atker=e:GetHandler():GetEquipTarget():GetBattleTarget()
	  if atker~=nil and atker:IsOnField() and not atker:IsStatus(STATUS_BATTLE_DESTROYED) then
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(0)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,tp)
	if Duel.Destroy(atker,REASON_EFFECT)>0 then Duel.BreakEffect() Duel.Damage(1-tp,1000,REASON_EFFECT) end end
end
