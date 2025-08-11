--黑魔导女孩 LV6(ZCG)
function c77240196.initial_effect(c)
    --破坏
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetCondition(c77240196.condition)
    e1:SetOperation(c77240196.operation)
    c:RegisterEffect(e1)

    --attack
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c77240196.op)
	c:RegisterEffect(e2)
end

function c77240196.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end

function c77240196.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
end

function c77240196.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x10a2)
end

function c77240196.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77240196.filter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
    local e1=Effect.CreateEffect(tc)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(400)
    tc:RegisterEffect(e1)
    tc=g:GetNext()
    end
end