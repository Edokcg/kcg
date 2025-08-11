--无名-克里之心
function c77239497.initial_effect(c)
    --target
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c77239497.atlimit)
    e1:SetValue(1)
    c:RegisterEffect(e1)
	
    --battle indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
	
    --
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetTarget(c77239497.damtg)
    e4:SetOperation(c77239497.damop)
    c:RegisterEffect(e4)
end
----------------------------------------------------------------
function c77239497.atlimit(e,c)
    return c~=e:GetHandler()
end
----------------------------------------------------------------
function c77239497.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(e:GetHandler():GetAttack()/2)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetAttack()/2)
end
function c77239497.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239497.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        local tc=g:GetFirst()
            Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetValue(aux.imval2)
            tc:RegisterEffect(e1)
end
function c77239497.filter(c,e,tp)
    return c:IsCode(77238991) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end