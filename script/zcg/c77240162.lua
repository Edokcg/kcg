--殉道者 魅惑邪眼
function c77240162.initial_effect(c)
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1)
    e1:SetTarget(c77240162.target)
    e1:SetOperation(c77240162.operation)
    c:RegisterEffect(e1)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240162.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240162.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240162.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77240162.disop)
    c:RegisterEffect(e13)
end
--[[function c77240162.thfilter(c)
    return c:IsFacedown() and c:IsAbleToHand()
end
function c77240162.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c77240162.thfilter(chkc) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,c77240162.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c77240162.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
    end
end]]

function c77240162.cfilter(c)
	return c:IsControlerCanBeChanged()
end

function c77240162.cfilter2(c)
	return not c:IsHasEffect(EFFECT_CANNOT_CHANGE_CONTROL)
end

function c77240162.cfilter3(c)
	return c:IsFacedown() and c:IsControlerCanBeChanged() or (c:IsFacedown() and not c:IsHasEffect(EFFECT_CANNOT_CHANGE_CONTROL))
end

function c77240162.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c77240162.cfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (Duel.IsExistingMatchingCard(c77240162.cfilter2,tp,0,LOCATION_SZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end

function c77240162.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		g=Duel.SelectMatchingCard(tp,c77240162.cfilter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g then
		local tc=g:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			Duel.GetControl(tc,tp)
		else
			local loc=LOCATION_SZONE
			if tc:IsLocation(LOCATION_FZONE) then loc=LOCATION_FZONE end
			Duel.MoveToField(tc,tp,tp,loc,tc:GetPosition(),true)
		end
    end
end

function c77240162.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240162.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240162.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end