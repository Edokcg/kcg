--达姿的仪式
function c77239239.initial_effect(c)
    c:EnableReviveLimit()
	
    --Cannot Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    --Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239239.spcon)
    e2:SetOperation(c77239239.spop)
    c:RegisterEffect(e2)	
	
    --Cost Change
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_LPCOST_CHANGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(1,0)
    e3:SetValue(c77239239.costchange)
    c:RegisterEffect(e3)	

	--破坏抗性
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e5)

    --效果抗性
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetValue(c77239239.efilter)
    c:RegisterEffect(e6)	
	
    --spsummon
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77239239,0))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_SPSUMMON_SUCCESS)
    e7:SetTarget(c77239239.sptg)
    e7:SetOperation(c77239239.spop1)
    c:RegisterEffect(e7)	
end
----------------------------------------------------------------------
function c77239239.spfilter(c)
    return c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToGraveAsCost()
end
function c77239239.spcon(e,c)
    if c==nil then return true end
    return Duel.IsExistingMatchingCard(c77239239.spfilter,c:GetControler(),LOCATION_DECK,0,1,nil)
end
function c77239239.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239239.spfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
----------------------------------------------------------------------
function c77239239.costchange(e,re,rp,val)
    if re and not re:GetHandler():IsCode(9236985) then
        return 0
    else
        return val
    end
end
----------------------------------------------------------------------
function c77239239.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
----------------------------------------------------------------------
function c77239239.filter(c,e,tp)
    return c:IsCode(77239230) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239239.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239239.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77239239.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239239.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end

