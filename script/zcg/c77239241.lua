--奥利哈刚 末日之音(ZCG)
function c77239241.initial_effect(c)
    c:EnableCounterPermit(0xa11)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Add counter
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c77239241.accon)
    e2:SetOperation(c77239241.acop)
    c:RegisterEffect(e2)   
end
--------------------------------------------------------------------
function c77239241.accon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp
end
--------------------------------------------------------------------
function c77239241.acop(e,tp,eg,ep,ev,re,r,rp)
  e:GetHandler():AddCounter(0xa11,1)
  if e:GetHandler():GetCounter(0xa11)>=6 then
   Duel.Win(tp,0x0) end
end
