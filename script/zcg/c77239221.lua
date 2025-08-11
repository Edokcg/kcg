--奥利哈刚 米诺(ZCG)
function c77239221.initial_effect(c)   
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetCondition(c77239221.condition)
    e1:SetTarget(c77239221.target)
    e1:SetOperation(c77239221.activate)
    c:RegisterEffect(e1)

    --auto be attacked
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e2:SetValue(c77239221.atlimit)
    c:RegisterEffect(e2)
end
---------------------------------------------------------------------------
function c77239221.atlimit(e,c)
	return c~=e:GetHandler()
end
---------------------------------------------------------------------------
function c77239221.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c77239221.filter(c,e,tp)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
function c77239221.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(c77239221.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c77239221.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77239221.activate(e,tp,eg,ep,ev,re,r,rp)
    local def=e:GetHandler():GetDefense()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(def)
        tc:RegisterEffect(e1)
    end
end

