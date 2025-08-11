--无名-提玛之心
function c77239496.initial_effect(c)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239496,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCondition(c77239496.eqcon)
	e2:SetTarget(c77239496.eqtg)
	e2:SetOperation(c77239496.eqop)
	c:RegisterEffect(e2)
    --[[equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239496,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239496.eqtg)
    e1:SetOperation(c77239496.eqop)
    c:RegisterEffect(e1)
    --eqlimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c77239496.eqlimit)
    c:RegisterEffect(e2)]]
	
    --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239496,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c77239496.sumtg)
	e1:SetOperation(c77239496.sumop)
	c:RegisterEffect(e1)

    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239496,3))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c77239496.condition)
    e3:SetTarget(c77239496.target)
    e3:SetOperation(c77239496.operation)
    c:RegisterEffect(e3)
end
-------------------------------------------------------------------

function c77239496.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c77239496.spfilter(c)
	return c:IsFaceup()
end
function c77239496.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239496.spfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c77239496.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c77239496.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c77239496.eqop(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetValue(c77239496.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--immune
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(c77239496.efilter1)
    c:RegisterEffect(e2)
	
end
function c77239496.eqlimit(e,c)
	return c==e:GetLabelObject()
end

--[[function c77239496.eqlimit(e,c)
    return c:IsFaceup()
end
function c77239496.filter(c)
    return c:IsFaceup()
end
function c77239496.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239496.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c77239496.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c77239496.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77239496.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c77239496.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end]]
-------------------------------------------------------------------

function c77239496.filter(c,e,tp)
	return c:IsCode(77239491) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239496.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239496.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239496.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77239496.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--[[function c77239496.filter1(c,e,tp)
    return c:IsCode(77239491) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239496.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239496.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239496.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239496.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end]]
-------------------------------------------------------------------
function c77239496.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function c77239496.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,3,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239496.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(g,REASON_EFFECT)
end

function c77239496.efilter1(e,te)
    return te:GetOwner()~=e:GetOwner()
end