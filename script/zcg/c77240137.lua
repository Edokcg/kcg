--炎斗火域
function c77240137.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(c77240137.condition)
    e1:SetTarget(c77240137.target)
    e1:SetOperation(c77240137.activate)
    c:RegisterEffect(e1)

    --
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c77240137.descon)
    e2:SetOperation(c77240137.deop)
    c:RegisterEffect(e2)
end
function c77240137.condition(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c77240137.filter(c)
    return c:IsAbleToGrave()
end
function c77240137.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240137.filter,tp,0,LOCATION_MZONE+LOCATION_HAND,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77240137.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c77240137.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    end
end

function c77240137.descon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_DESTROY)~=0
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c77240137.deop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end