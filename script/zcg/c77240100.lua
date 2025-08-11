--神炎皇 甜点师
function c77240100.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(51945556,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77240100.target)
    e1:SetOperation(c77240100.activate)
    c:RegisterEffect(e1)

    --离场
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetTarget(c77240100.atkcon)
    e2:SetOperation(c77240100.atkop)
    c:RegisterEffect(e2)
end
function c77240100.filter(c)
    return c:IsFacedown()
end
function c77240100.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and c77240100.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77240100.filter,tp,0,LOCATION_SZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
    Duel.SelectTarget(tp,c77240100.filter,tp,0,LOCATION_SZONE,1,1,nil)
end
function c77240100.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    Duel.ConfirmCards(tp,tc)
    if tc:IsType(TYPE_TRAP) then
        Duel.Destroy(tc,REASON_EFFECT)
    else
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
    end
end

function c77240100.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c77240100.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end