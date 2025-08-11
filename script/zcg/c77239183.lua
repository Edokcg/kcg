--暴君炸裂龙(ZCG)
function c77239183.initial_effect(c)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c77239183.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c77239183.spcon)
    e2:SetOperation(c77239183.spop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
---------------------------------------------------------------------------
function c77239183.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c77239183.spfilter(c)
    return c:IsCode(11082056) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c77239183.spfilter1(c)
    return c:IsCode(57470761) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c77239183.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c77239183.spfilter,tp,LOCATION_SZONE+LOCATION_MZONE,0,1,nil,c)
		and Duel.IsExistingMatchingCard(c77239183.spfilter1,tp,LOCATION_SZONE+LOCATION_MZONE,0,1,nil,c)
end
function c77239183.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239183.spfilter,tp,LOCATION_SZONE+LOCATION_MZONE,0,1,1,nil,c)
    local g1=Duel.SelectMatchingCard(tp,c77239183.spfilter1,tp,LOCATION_SZONE+LOCATION_MZONE,0,1,1,nil,c)	 
    g1:Merge(g)	
	c:SetMaterial(g1)
    Duel.SendtoGrave(g1,REASON_COST)
end