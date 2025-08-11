--女子佣兵 机甲师
function c77239536.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239536,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c77239536.sptg)
    e1:SetOperation(c77239536.spop)
    c:RegisterEffect(e1)

    --direct attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DIRECT_ATTACK)
    e2:SetCondition(c77239536.spcon)	
    c:RegisterEffect(e2)

    --actlimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(1,1)
    e3:SetValue(c77239536.aclimit)
    e3:SetCondition(c77239536.actcon)
    c:RegisterEffect(e3)	
end
------------------------------------------------------------------------------------
function c77239536.filter(c,e,tp)
    return c:IsSetCard(0xa80) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239536.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239536.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239536.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239536.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
------------------------------------------------------------------------------------
function c77239536.spcon(e,c)
    if c==nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)<2       
end
------------------------------------------------------------------------------------
function c77239536.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c77239536.actcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end