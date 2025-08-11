--教皇的锡杖(ZCG)
function c77239067.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239067.tg)
    e1:SetOperation(c77239067.op)
    c:RegisterEffect(e1)
end
function c77239067.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c77239067.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(1-tp,1,REASON_EFFECT)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetValue(c77239067.indval)
    Duel.RegisterEffect(e2,tp)
end
function c77239067.indval(e,re,rp)
    return rp~=e:GetHandlerPlayer()
end
