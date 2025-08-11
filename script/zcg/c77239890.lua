--核变异兽 叢林王(ZCG)
function c77239890.initial_effect(c)
    Pendulum.AddProcedure(c)
	--
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetDescription(aux.Stringid(77239890,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1)	
    e1:SetTarget(c77239890.target)
    e1:SetOperation(c77239890.activate)
    c:RegisterEffect(e1)

    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    e2:SetCondition(c77239890.condition)	
    e2:SetTarget(c77239890.target1)
    e2:SetOperation(c77239890.activate1)
    c:RegisterEffect(e2)	
end
---------------------------------------------------------------------------------------
function c77239890.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c77239890.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(1000)
        tc:RegisterEffect(e1)
    end
end
---------------------------------------------------------------------------------------
function c77239890.cfilter(c,e,tp)
    return c:GetSummonPlayer()==tp 
end
function c77239890.condition(e,tp,eg,ep,ev,re,r,rp)
    return  eg:IsExists(c77239890.cfilter,1,nil,nil,tp)
end
function c77239890.filter(c)
    return c:IsAbleToGrave()
end
function c77239890.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239890.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c77239890.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c77239890.activate1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239890.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end



