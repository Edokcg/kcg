--殉道者 龙骑鲁克
function c77239320.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239320,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCountLimit(1)	
    e1:SetCondition(c77239320.condition)
    e1:SetTarget(c77239320.target)
    e1:SetOperation(c77239320.activate)
    c:RegisterEffect(e1) 

	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239320.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239320.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239320.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239320.disop)
    c:RegisterEffect(e13)
end
------------------------------------------------------------------
function c77239320.cfilter(c,tp)
    return c:IsSetCard(0xa60) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c77239320.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239320.cfilter,2,nil,tp)
end
function c77239320.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239320.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=0
    local def=0	
    local tc=eg:GetFirst()
    while tc do	
	    atk=atk+tc:GetAttack()	
	    def=def+tc:GetDefense()
        tc=eg:GetNext()
    end	
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_DEFENSE)
        e2:SetValue(def)
        e2:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e2)		
    end
end
---------------------------------------------------------------------------------
function c77239320.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239320.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239320.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
