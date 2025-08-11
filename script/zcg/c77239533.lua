--女子佣兵 雷闪
function c77239533.initial_effect(c)
    --battle indestructable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    --atk up
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c77239533.target)
    e2:SetOperation(c77239533.operation)
    c:RegisterEffect(e2)	
	
	--
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_HANDES)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c77239533.condition3)
    e3:SetTarget(c77239533.target3)
    e3:SetOperation(c77239533.activate3)
    c:RegisterEffect(e3)	
end
------------------------------------------------------------
function c77239533.filter(c)
    return c:IsSetCard(0xa80) and c:IsType(TYPE_MONSTER)
end
function c77239533.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingMatchingCard(c77239533.filter,tp,LOCATION_HAND,0,1,nil) end
end
function c77239533.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c77239533.filter,tp,LOCATION_HAND,0,nil)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(g:GetCount()*500)
    c:RegisterEffect(e1)    
end
------------------------------------------------------------
function c77239533.condition3(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_EFFECT)
end
function c77239533.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    if chk==0 then return ct>0 end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,ct)
end
function c77239533.activate3(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)   
end
