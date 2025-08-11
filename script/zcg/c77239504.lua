--女子佣兵 镜灵(ZCG)
function c77239504.initial_effect(c)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239504,4))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c77239504.spcon)
    e2:SetOperation(c77239504.spop)
    c:RegisterEffect(e2)
	
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239504,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c77239504.target)
    e1:SetOperation(c77239504.operation)
    c:RegisterEffect(e1)	
end
-----------------------------------------------------------------
function c77239504.cfilter(c)
    return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa80)
end
function c77239504.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239504.cfilter,c:GetControler(),LOCATION_HAND,0,1,nil)
end
function c77239504.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239504.cfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
-----------------------------------------------------------------
function c77239504.atkfilter(c)
    return c:IsSetCard(0xa80) and c:IsFaceup()
end
function c77239504.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local sg=Duel.GetMatchingGroupCount(c77239504.atkfilter,tp,LOCATION_MZONE,0,nil)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,sg,sg,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239504.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(g,REASON_EFFECT)
end

