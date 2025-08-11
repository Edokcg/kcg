--殉道者 梵天摩诃
function c77239314.initial_effect(c)
    c:EnableReviveLimit()
	
	--出场
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239314,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_REMOVE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
    e1:SetCondition(c77239314.condition)
    e1:SetTarget(c77239314.target)
    e1:SetOperation(c77239314.operation)
    c:RegisterEffect(e1)
	
	--攻击力
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_SET_ATTACK)
    e2:SetValue(c77239314.value)
    c:RegisterEffect(e2)

	--除外
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)	
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c77239314.con)	
    e3:SetTarget(c77239314.target)
    e3:SetOperation(c77239314.operation1)
    c:RegisterEffect(e3)

    --自爆
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetCondition(c77239314.descon)
    c:RegisterEffect(e4)


	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239314.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239314.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239314.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239314.disop)
    c:RegisterEffect(e13)
end
--------------------------------------------------------------------------
function c77239314.filter(c)
    return not c:IsType(TYPE_TOKEN)
end
function c77239314.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239314.filter,1,nil)
end
function c77239314.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239314.operation(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
        e:GetHandler():CompleteProcedure()		
    end
end
--------------------------------------------------------------------------
function c77239314.value(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*1000
end
--------------------------------------------------------------------------
function c77239314.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239314.filter1(c)
    return c:IsAbleToRemove()
end
function c77239314.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239314.filter1,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c77239314.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239314.filter1,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)      
    end
end
--------------------------------------------------------------------------
function c77239314.descon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
end
-----------------------------------------------------------------------------
function c77239314.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239314.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239314.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
