--龙型-凯尔特
function c77239670.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetOperation(c77239670.operation)
    c:RegisterEffect(e1)

    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetTarget(c77239670.target)
    e2:SetOperation(c77239670.activate)
    c:RegisterEffect(e2)

	--
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)	
    e3:SetCondition(c77239670.con)	
    e3:SetTarget(c77239670.target1)
    e3:SetOperation(c77239670.operation1)
    c:RegisterEffect(e3)	
end
------------------------------------------------------------------
function c77239670.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK)
    e1:SetValue(c77239670.adval)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
    c:RegisterEffect(e1)
end
function c77239670.adval(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*700
end
------------------------------------------------------------------
function c77239670.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239670.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.SendtoGrave(sg,REASON_EFFECT)
end
------------------------------------------------------------------
function c77239670.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239670.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239670.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239670.filter,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c77239670.operation1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239670.filter,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end



