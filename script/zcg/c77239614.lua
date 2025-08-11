--植物的愤怒 花蛙激光炮
function c77239614.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239614,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
    e1:SetTarget(c77239614.eqtg)
    e1:SetOperation(c77239614.eqop)
    c:RegisterEffect(e1)


    --destroy rep
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c77239614.reptg)
	e2:SetOperation(c77239614.repop)
	c:RegisterEffect(e2)
    --[[destroy sub
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    e3:SetCondition(aux.IsUnionState)
    e3:SetValue(1)
    c:RegisterEffect(e3)

    --eqlimit
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_EQUIP_LIMIT)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e7:SetValue(c77239614.eqlimit)
    c:RegisterEffect(e7)
	
    --atkup
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c77239614.atkcon)
    e5:SetOperation(c77239614.atkop)
    c:RegisterEffect(e5)]]
end
----------------------------------------------------------------
function c77239614.eqlimit(e,c)
    return c:IsSetCard(0xa90)
end
function c77239614.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa90)
end
function c77239614.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239614.spfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c77239614.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c77239614.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c77239614.eqop(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetValue(c77239614.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(2000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function c77239614.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--[[function c77239614.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239614.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c77239614.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c77239614.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77239614.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c77239614.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    --aux.SetUnionState(c)
end]]
----------------------------------------------------------------
function c77239614.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c77239614.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(77239614)==0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_EQUIP)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(2000)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e1)
        c:RegisterFlagEffect(77239614,RESET_EVENT+0x1fe0000,0,0)
        e:SetLabelObject(e1)
        e:SetLabel(2)
    else
        local pe=e:GetLabelObject()
        local ct=e:GetLabel()
        e:SetLabel(ct+1)
        pe:SetValue(ct*-300)
    end
end

function c77239614.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if chk==0 then return not tc:IsReason(REASON_REPLACE) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c77239614.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end