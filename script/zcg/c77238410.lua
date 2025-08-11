--冥界大邪神石板
function c77238410.initial_effect(c)
    c:EnableReviveLimit()
	
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77238410.spcon)
    c:RegisterEffect(e1)
	
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(c77238410.target)
    e2:SetOperation(c77238410.operation)
    c:RegisterEffect(e2)
end
---------------------------------------------------------------------
function c77238410.spfilter(c,code)
    return c:IsCode(code) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c77238410.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77238410.spfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,77238291)
        and Duel.IsExistingMatchingCard(c77238410.spfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,77238292)
        and Duel.IsExistingMatchingCard(c77238410.spfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,77238293)
        and Duel.IsExistingMatchingCard(c77238410.spfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,77238294)
        and Duel.IsExistingMatchingCard(c77238410.spfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,77238295)
        and Duel.IsExistingMatchingCard(c77238410.spfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,77238296)
        and Duel.IsExistingMatchingCard(c77238410.spfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,77238297)
end
---------------------------------------------------------------------
function c77238410.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,0)
end
function c77238410.operation(e,tp,eg,ep,ev,re,r,rp)
    --destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetTarget(c77238410.target1)
	e1:SetOperation(c77238410.operation)
	e:GetHandler():RegisterEffect(e1)
end
function c77238410.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77238410.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
