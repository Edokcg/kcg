--斗
function c77239072.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(c77239072.condition)
    e1:SetTarget(c77239072.target)
    e1:SetOperation(c77239072.activate)
    c:RegisterEffect(e1)
end
function c77239072.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c77239072.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c77239072.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) --[[and tc:IsAttackable()]] and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
        Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	    Duel.Damage(1-tp,300,REASON_EFFECT)		
    end
end
