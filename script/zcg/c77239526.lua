--女子佣兵 武藏(ZCG)
function c77239526.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c77239526.target)
    e1:SetOperation(c77239526.operation)
    c:RegisterEffect(e1)
end

function c77239526.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return true end
    local c=e:GetHandler()
    local dam=c:GetPreviousAttackOnField()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
    local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239526.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
    local tc=Duel.GetFirstTarget()
    local dam=tc:GetAttack()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
        Duel.Damage(1-tp,dam,REASON_EFFECT)
    end
end
