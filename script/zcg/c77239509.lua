--女子佣兵 风灵
function c77239509.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239509.ctltg)	
    e1:SetOperation(c77239509.defop)
    c:RegisterEffect(e1)
end
function c77239509.ctltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsControlerCanBeChanged() and Duel.GetAttacker():IsControlerCanBeChanged() end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c77239509.defop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local d=Duel.GetAttacker()	
    if c:IsFaceup() and c:IsRelateToEffect(e) then      
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        e1:SetValue(0)
        c:RegisterEffect(e1)
		Duel.GetControl(c,1-tp)
		Duel.GetControl(d,tp)
		Duel.CalculateDamage(c,d)
    end
end
