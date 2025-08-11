--绒儿的暗伤(ZCG)
function c77239170.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_BATTLE_DESTROYED)
    e1:SetCondition(c77239170.condition)
    e1:SetTarget(c77239170.target)
    e1:SetOperation(c77239170.activate)
    c:RegisterEffect(e1)
end
function c77239170.cfilter(c,tp)
    return c:GetPreviousControler()==tp
end
function c77239170.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer() and eg:IsExists(c77239170.cfilter,1,nil,tp)
end
function c77239170.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
end
function c77239170.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local dam=tc:GetAttack()
    if tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
        Duel.Damage(1-tp,dam,REASON_EFFECT)
    end
end
