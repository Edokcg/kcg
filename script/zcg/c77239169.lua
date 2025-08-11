--史莱姆突破口(ZCG)
function c77239169.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c77239169.target)
    e1:SetOperation(c77239169.activate)
    c:RegisterEffect(e1)
end
function c77239169.filter(c,tp)
    return c:IsFaceup()
end
function c77239169.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c77239169.filter,1,nil,tp) end
    Duel.SetTargetCard(eg)
end
function c77239169.filter2(c,e,tp)
    return c:IsFaceup() and c:IsRelateToEffect(e) 
end
function c77239169.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c77239169.filter2,nil,e,tp)
    local atk=g:GetFirst():GetAttack()
    local tc=g:GetFirst()
    if Duel.Recover(tp,atk,REASON_EFFECT) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end

