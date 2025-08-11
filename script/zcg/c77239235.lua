--奥利哈刚 万蛇神(ZCG)
function c77239235.initial_effect(c)
    c:EnableReviveLimit()
    c:EnableCounterPermit(0xa11)
	
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
	
    --攻击力提升
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c77239235.atkval)
    c:RegisterEffect(e2)
	
    --战破特殊召唤
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239235,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BATTLE_DESTROYED)
    e3:SetCondition(c77239235.condition)
    e3:SetCost(c77239235.cost)
    e3:SetTarget(c77239235.target)
    e3:SetOperation(c77239235.operation)
    c:RegisterEffect(e3)
	
    --抗性
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    --e4:SetValue(aux.tgval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetValue(c77239235.efilter)
    c:RegisterEffect(e5)
	
    --指示物
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_COUNTER)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_BATTLE_DAMAGE)
    e6:SetCondition(c77239235.ctcon)
    e6:SetOperation(c77239235.ctop)
    c:RegisterEffect(e6)
end
----------------------------------------------------------------------------
function c77239235.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
----------------------------------------------------------------------------
function c77239235.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa50)
end
function c77239235.atkval(e,c)
    return Duel.GetMatchingGroupCount(c77239235.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end
----------------------------------------------------------------------------
function c77239235.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c77239235.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa50) and c:IsAbleToRemoveAsCost()
end
function c77239235.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239235.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239235.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77239235.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239235.operation(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
    end
end
----------------------------------------------------------------------------
function c77239235.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c77239235.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0xa11,1)
    if e:GetHandler():GetCounter(0xa11)>=3 then
        Duel.Win(tp,0x0) 
    end
end
