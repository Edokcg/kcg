--装甲 药水兵
function c77240141.initial_effect(c)
    --[[equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(65685470,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77240141.eqtg)
    e1:SetOperation(c77240141.eqop)
    c:RegisterEffect(e1)

    --Atk up
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c77240141.value)
    e2:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e2)]]
	
    --equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c77240141.eqcon)
	e1:SetTarget(c77240141.eqtg)
	e1:SetOperation(c77240141.eqop)
	c:RegisterEffect(e1)

    --negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c77240141.condition2)
	e2:SetTarget(c77240141.target2)
	e2:SetOperation(c77240141.operation2)
	c:RegisterEffect(e2)
	
    --[[destroy
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c77240141.condition)
    e4:SetTarget(c77240141.damtg)
    e4:SetOperation(c77240141.damop)
    c:RegisterEffect(e4)]]

    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(c77240141.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0,1)
    e53:SetTarget(c77240141.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0,1)
    e54:SetTarget(c77240141.distg2)
    c:RegisterEffect(e54)
end
--------------------------------------------------------------------
function c77240141.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xa110)
end
--[[function c77240141.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77240141.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c77240141.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c77240141.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77240141.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c77240141.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end]]

function c77240141.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c77240141.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa110)
end
function c77240141.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77240141.spfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c77240141.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c77240141.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c77240141.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c77240141.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c77240141.value)
    --e2:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e2)
end
function c77240141.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--------------------------------------------------------------------
function c77240141.value(e,c)
    return e:GetHandler():GetAttack()
end
--------------------------------------------------------------------
function c77240141.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsPosition(POS_FACEUP_DEFENSE) and tc:IsSetCard(0xa110)
end
function c77240141.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if chk==0 then return a:IsOnField() and a:GetControler(1-tp) end
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
end
function c77240141.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local dam=tc:GetAttack()
	if tc:IsRelateToEffect(e) and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		 Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
--------------------------------------------------------------------
--[[function c77240141.cfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()~=tp and c:IsReason(REASON_EFFECT)
end
function c77240141.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77240141.cfilter,1,nil,tp) and re and re:GetHandler()==e:GetHandler()
end
function c77240141.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local dam=eg:GetHandler():GetAttack()
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77240141.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end]]

function c77240141.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsControler(1-tp) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240141.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
        and c:GetCardTarget():IsContains(e:GetHandler())
end