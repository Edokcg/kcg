--女子佣兵 枪手(ZCG)
function c77239529.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239529.spcon)
    c:RegisterEffect(e1)

    --破坏
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(c77239529.target)
    e2:SetOperation(c77239529.activate)
    c:RegisterEffect(e2)
end
-------------------------------------------------------------
function c77239529.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa80) and c:IsType(TYPE_MONSTER)
end
function c77239529.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239529.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
-------------------------------------------------------------
function c77239529.filter(c)
    return c:IsType(TYPE_TRAP) and c:IsFaceup()
end
function c77239529.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c77239529.filter,tp,0,LOCATION_ONFIELD,1,c) end
    local sg=Duel.GetMatchingGroup(c77239529.filter,tp,0,LOCATION_ONFIELD,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239529.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239529.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
    Duel.Destroy(sg,REASON_EFFECT)
end

