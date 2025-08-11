--殉道者毁灭区(ZCG)
function c77239372.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239372,0))
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c77239372.condition)
    e2:SetOperation(c77239372.operation)
    c:RegisterEffect(e2)
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239372.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239372.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239372.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77239372.disop)
    c:RegisterEffect(e13)
end
------------------------------------------------------------------------------
function c77239372.filter(c,tp)
    return c:IsType(TYPE_MONSTER) and c:GetControler()==1-tp
end
function c77239372.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239372.filter,1,nil,tp)
end
function c77239372.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local op=Duel.SelectOption(tp,aux.Stringid(77239372,0),aux.Stringid(77239372,1),aux.Stringid(77239372,2))
    local tc=eg:GetFirst()
    if op==0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    elseif op==1 then
        Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
    elseif op==2 then
        Duel.Damage(1-tp,tc:GetAttack()/2,REASON_EFFECT)
    end   
end
------------------------------------------------------------------------------
function c77239372.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239372.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239372.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end


