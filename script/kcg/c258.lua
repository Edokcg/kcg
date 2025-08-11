--DZW－魔装鵺妖衣
local s,id=GetID()
function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(706925,1))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(s.destg)
	e0:SetOperation(s.desop)
	c:RegisterEffect(e0)

	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14745409,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	aux.AddZWEquipLimit(c,nil,function(tc,c,tp) return s.filter(tc) and tc:IsControler(tp) end,s.equipop,e1)

	--destroy sub
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
    local e5=e4:Clone()
	e5:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e5)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6330307,1))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)	
    e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
s.listed_series={0x7f}

function s.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.desfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
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
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	s.equipop(c,e,tp,tc)
end
function s.equipop(c,e,tp,tc)
	if not aux.EquipAndLimitRegister(c,e,tp,tc) then return end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return a~=nil and at~=nil and e:GetHandler():GetEquipTarget() and a==e:GetHandler():GetEquipTarget() and at:IsRelateToBattle() 
    and a:CanChainAttack() and ep==tp     
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=e:GetHandler():GetEquipTarget()
	local at=Duel.GetAttackTarget()
	if a and a:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(a:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		Duel.ChainAttack()
	end
end
