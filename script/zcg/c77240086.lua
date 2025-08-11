--千年女娲石
function c77240086.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --remain field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e2)

    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c77240086.condition)
    e3:SetOperation(c77240086.operation)
    c:RegisterEffect(e3)
end
-------------------------------------------------------------------
function c77240086.filter(c,tp)
    return c:IsType(TYPE_MONSTER) and c:GetControler()==1-tp and (c:IsPreviousLocation(LOCATION_HAND) or c:IsPreviousLocation(LOCATION_MZONE))
end
function c77240086.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77240086.filter,1,nil,tp)
end
function c77240086.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local rec=0
    while tc do
        local atk=tc:GetAttack()
        rec=rec+atk
        tc=eg:GetNext()
    end
    Duel.Recover(tp,rec,REASON_EFFECT)
end