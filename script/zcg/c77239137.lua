--传说-青眼之魂
function c77239137.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239137,0))
    e1:SetCategory(CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77239137.tg)
    e1:SetOperation(c77239137.op)
    c:RegisterEffect(e1)
	
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239137,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCondition(c77239137.eqcon)
	e2:SetTarget(c77239137.eqtg)
	e2:SetOperation(c77239137.eqop)
	c:RegisterEffect(e2)
	
    --[[equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239137,1))
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77239137.eqtg)
    e2:SetOperation(c77239137.eqop)
    c:RegisterEffect(e2)
	
    --eqlimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(c77239137.eqlimit)
    c:RegisterEffect(e3)
	
    --Atk up
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetValue(2000)
    e4:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e4)]]

    --[[destroy sub
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e5:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    e5:SetCondition(aux.IsUnionState)
    e5:SetValue(1)
    c:RegisterEffect(e5)]]

    --desrep
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(c77239137.destg)
	e5:SetOperation(c77239137.desop)
	c:RegisterEffect(e5)

    --dam
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DAMAGE)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
    e6:SetCode(EVENT_BATTLE_DAMAGE)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCondition(c77239137.rmcon)
    e6:SetTarget(c77239137.damtg)
    e6:SetOperation(c77239137.damop)
    c:RegisterEffect(e6)

    --special summon
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77239137,2))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e7:SetCode(EVENT_TO_GRAVE)
    e7:SetTarget(c77239137.target)
    e7:SetOperation(c77239137.operation)
    c:RegisterEffect(e7)	
end
-------------------------------------------------------------------
function c77239137.filter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c77239137.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239137.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239137.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239137.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-------------------------------------------------------------------
--[[function c77239137.eqlimit(e,c)
    return c:IsSetCard(0xdd)
end
function c77239137.filter1(c)
    return c:IsFaceup() and c:IsSetCard(0xdd)
end
function c77239137.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c77239137.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c77239137.filter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77239137.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c77239137.filter1(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end]]

function c77239137.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c77239137.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdd)
end
function c77239137.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239137.spfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c77239137.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c77239137.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c77239137.eqop(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetValue(c77239137.eqlimit)
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
function c77239137.eqlimit(e,c)
	return c==e:GetLabelObject()
end

-------------------------------------------------------------------
function c77239137.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c77239137.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ec=e:GetHandler():GetEquipTarget()
    if chk==0 then return ec and ec:GetLevel()>0 end
    local lv=ec:GetLevel()
    local dam=lv*300
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77239137.damop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ec=e:GetHandler():GetEquipTarget()
    if not ec then return end
    local dam=ec:GetLevel()*300
    Duel.Damage(p,dam,REASON_EFFECT)
end
-------------------------------------------------------------------
function c77239137.filter2(c,e,sp)
    return c:IsSetCard(0xdd) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c77239137.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239137.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77239137.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239137.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c77239137.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if chk==0 then return not tc:IsReason(REASON_REPLACE) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c77239137.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end