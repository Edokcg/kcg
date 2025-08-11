--闪光爆发
function c77239057.initial_effect(c)
    --攻击时特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(c77239057.condition)
    e1:SetTarget(c77239057.target)
    e1:SetOperation(c77239057.operation)
    c:RegisterEffect(e1)
end
function c77239057.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp)
end
function c77239057.filter(c,e,tp)
    return c:IsSetCard(0xa13) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239057.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239057.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239057.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239057.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
        local a=Duel.GetAttacker()
        if --[[a:IsAttackable() and]] not a:IsImmuneToEffect(e) then
            Duel.CalculateDamage(a,g:GetFirst())
        end
    end
end
