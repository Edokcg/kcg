--见习魔术师·玛娜(ZCG)
function c77239960.initial_effect(c)
    --equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239960,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c77239960.eqcon)
	e1:SetTarget(c77239960.eqtg)
	e1:SetOperation(c77239960.eqop)
	c:RegisterEffect(e1)
    --[[equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239960,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239960.eqtg)
    e1:SetOperation(c77239960.eqop)
    c:RegisterEffect(e1)]]
	
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239960,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77239960.cost)
    e2:SetTarget(c77239960.sptg)
    e2:SetOperation(c77239960.spop)
    c:RegisterEffect(e2)	

    --[[Atk up
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(1000)
    e3:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e3)
    --Def up
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    e4:SetValue(1000)
    e4:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e4)]]
    --destroy sub
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e5:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    --e5:SetCondition(aux.IsUnionState)
    e5:SetValue(1)
    c:RegisterEffect(e5)

    --eqlimit
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_EQUIP_LIMIT)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e7:SetValue(c77239960.eqlimit)
    c:RegisterEffect(e7)
	
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e8:SetCode(EVENT_LEAVE_FIELD)	
    e8:SetTarget(c77239960.target)
    e8:SetOperation(c77239960.activate)
    c:RegisterEffect(e8)
end
----------------------------------------------------------------------------------
function c77239960.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c77239960.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x30a2)
end
function c77239960.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239960.spfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c77239960.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c77239960.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c77239960.eqop(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetValue(c77239960.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
    --defenseup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(1000)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
end
function c77239960.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--[[function c77239960.eqlimit(e,c)
    return c:IsSetCard(0x30a2)
end
function c77239960.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x30a2)
end
function c77239960.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239960.filter(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(77239960)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c77239960.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c77239960.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
    e:GetHandler():RegisterFlagEffect(77239960,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c77239960.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c77239960.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end]]
----------------------------------------------------------------------------------
function c77239960.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,500)
    else Duel.PayLPCost(tp,500) end
end
function c77239960.filter1(c,e,tp)
    return c:IsSetCard(0x30a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239960.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239960.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239960.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239960.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
----------------------------------------------------------------------------------
--[[function c77239960.srcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end]]
function c77239960.filter2(c)
    return c:IsCode(77239978) and c:IsAbleToHand()
end
function c77239960.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239960.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c77239960.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239960.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

