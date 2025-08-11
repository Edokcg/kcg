--太阳神龙的加护
function c77239927.initial_effect(c)
    --summon & set with no tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239927,0))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c77239927.ntcon)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e2)
	
    --summon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)

    --summon success
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetOperation(c77239927.sumsuc)
    c:RegisterEffect(e4)

    --atk/def
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(c77239927.adval)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e7)

    --remove
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(77239927,0))	
    e8:SetCategory(CATEGORY_REMOVE)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e8:SetCountLimit(1)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCost(c77239927.cost)
    e8:SetTarget(c77239927.target)
    e8:SetOperation(c77239927.operation)
    c:RegisterEffect(e8)	
end
-------------------------------------------------------------------------
function c77239927.spfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_DIVINE)
end
function c77239927.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c77239927.spfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
-------------------------------------------------------------------------
function c77239927.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
------------------------------------------------------------------------
function c77239927.adval(e,c)
    return Duel.GetLP(c:GetControler())+Duel.GetLP(1-c:GetControler())
end
------------------------------------------------------------------------
function c77239927.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,500) end
    Duel.PayLPCost(tp,500)
end
function c77239927.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77239927.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end




