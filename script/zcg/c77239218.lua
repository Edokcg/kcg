--奥利哈刚 亡灵士兵部队(ZCG)
function c77239218.initial_effect(c)
    c:EnableCounterPermit(0xa11)
    --特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77239218.sptg)
    e1:SetOperation(c77239218.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e3)
	
    --指示物
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239218,0))
    e4:SetCategory(CATEGORY_COUNTER)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c77239218.addccon)
    e4:SetTarget(c77239218.addct)
    e4:SetOperation(c77239218.addc)
    c:RegisterEffect(e4)
	
    --攻击力上升
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetValue(c77239218.attackup)
    c:RegisterEffect(e5)

    --破坏抗性
    local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77239218,1))		
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCost(c77239218.rmcost)
    e6:SetOperation(c77239218.rmop)
    c:RegisterEffect(e6)	
end
--------------------------------------------------------------------------------
function c77239218.filter(c,e,tp)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174))) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239218.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239218.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77239218.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239218.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--------------------------------------------------------------------------------
function c77239218.addccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239218.addct(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xa11)
end
function c77239218.addc(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0xa11,1)
    end
end
--------------------------------------------------------------------------------
function c77239218.attackup(e,c)
    return c:GetCounter(0xa11)*500
end
--------------------------------------------------------------------------------
function c77239218.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xa11,1,REASON_COST) end
    Duel.RemoveCounter(tp,1,0,0xa11,1,REASON_COST)
end
function c77239218.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e2)
end

