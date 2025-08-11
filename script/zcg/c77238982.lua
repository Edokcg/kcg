--幻神器-翼神龙之怒
function c77238982.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238982,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c77238982.sptg)
    e1:SetOperation(c77238982.spop)
    c:RegisterEffect(e1)
	
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77238982,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c77238982.eqcon)
	e2:SetTarget(c77238982.eqtg)
	e2:SetOperation(c77238982.eqop)
	c:RegisterEffect(e2)
	
    --[[Atk up
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(2000)
    e3:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e3)
    --Def up
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    e4:SetValue(2000)
    e4:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e4)]]
	
    --search
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetDescription(aux.Stringid(77238982,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE+LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetCost(c77238982.cost)
    e5:SetTarget(c77238982.target)
    e5:SetOperation(c77238982.activate)
    c:RegisterEffect(e5)
end
----------------------------------------------------------------------
function c77238982.filter(c,e,tp)
    return c:IsCode(10000010) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77238982.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77238982.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77238982.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77238982.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		--[[if not Duel.Equip(tp,c,tc,false) then return end
        aux.SetUnionState(c)]]
    end
end
----------------------------------------------------------------------
function c77238982.filter1(c)
    return c:IsAbleToRemoveAsCost()
end
function c77238982.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77238982.filter1,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77238982.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77238982.filter2(c)
    return c:IsAbleToHand()
end
function c77238982.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77238982.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77238982.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77238982.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c77238982.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c77238982.spfilter(c)
	return c:IsFaceup()
end
function c77238982.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77238982.spfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c77238982.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c77238982.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c77238982.eqop(e,tp,eg,ep,ev,re,r,rp)
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
	e1:SetValue(c77238982.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(2000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	--defenseup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(2000)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
end
function c77238982.eqlimit(e,c)
	return c==e:GetLabelObject()
end