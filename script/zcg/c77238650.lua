--三国传-刘备
function c77238650.initial_effect(c)
    c:EnableCounterPermit(COUNTER_SPELL)
	
    --cannot be battle target
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetCondition(c77238650.con)
    e1:SetValue(c77238650.tg)
    c:RegisterEffect(e1)
	
    --add counter
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetTarget(c77238650.addct)
    e2:SetOperation(c77238650.addc)
    c:RegisterEffect(e2)
	
	--
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCost(c77238650.cost)
    e3:SetCondition(c77238650.condition)
    e3:SetTarget(c77238650.target)
    e3:SetOperation(c77238650.activate)
    c:RegisterEffect(e3)
end
-----------------------------------------------------------------------
function c77238650.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsDefensePos()
end
function c77238650.tg(e,c)
    return c~=e:GetHandler()
end
-----------------------------------------------------------------------
function c77238650.addct(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,COUNTER_SPELL)
end
function c77238650.addc(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(COUNTER_SPELL,1)
    end
end
----------------------------------------------------------------------
function c77238650.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,COUNTER_SPELL,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,COUNTER_SPELL,1,REASON_COST)
end
function c77238650.condition(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and Duel.IsChainNegatable(ev)
end
function c77238650.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsChainNegatable(ev) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77238650.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end

