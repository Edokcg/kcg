--欧贝利斯克之甲虫恶魔
function c77238512.initial_effect(c)

    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
    e1:SetCondition(c77238512.spcon)
    e1:SetOperation(c77238512.spop)
    c:RegisterEffect(e1)

    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)

	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    c:RegisterEffect(e3)

    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetTarget(c77238512.target)
    e4:SetOperation(c77238512.activate)
    c:RegisterEffect(e4)


    --cannot trigger
    local e101=Effect.CreateEffect(c)
    e101:SetType(EFFECT_TYPE_FIELD)
    e101:SetCode(EFFECT_CANNOT_TRIGGER)
    e101:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e101:SetRange(LOCATION_MZONE)
    e101:SetTargetRange(0,0xa)
    e101:SetTarget(c77238512.distg)
    c:RegisterEffect(e101)
    --disable
    local e102=Effect.CreateEffect(c)
    e102:SetType(EFFECT_TYPE_FIELD)
    e102:SetCode(EFFECT_DISABLE)
    e102:SetRange(LOCATION_MZONE)
    e102:SetTargetRange(0,LOCATION_ONFIELD)
    e102:SetTarget(c77238512.distg)
    c:RegisterEffect(e102)
    --disable effect
    local e103=Effect.CreateEffect(c)
    e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e103:SetCode(EVENT_CHAIN_SOLVING)
    e103:SetRange(LOCATION_MZONE)
    e103:SetOperation(c77238512.disop)
    c:RegisterEffect(e103)
	--
    local e104=Effect.CreateEffect(c)
    e104:SetType(EFFECT_TYPE_FIELD)
    e104:SetCode(EFFECT_SELF_DESTROY)
    e104:SetRange(LOCATION_MZONE)
    e104:SetTargetRange(0,LOCATION_ONFIELD)
    e104:SetTarget(c77238512.distg)
    c:RegisterEffect(e104)	
end
--------------------------------------------------------------------------
function c77238512.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.CheckLPCost(tp,6000)
end
function c77238512.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,6000)
end
--------------------------------------------------------------------------
function c77238512.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77238512.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77238512.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(c77238512.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77238512.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77238512.filter,tp,0,LOCATION_ONFIELD,nil)
    local ct=Duel.Destroy(sg,REASON_EFFECT)
	if ct>0 then
	    Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
	end
end
--------------------------------------------------------------------------
function c77238512.distg(e,c)
    return c:IsSetCard(0xa90) or c:IsSetCard(0xa110)
end
function c77238512.disop(e,tp,eg,ep,ev,re,r,rp)
    if  (re:GetHandler():IsSetCard(0xa90) or re:GetHandler():IsSetCard(0xa110)) and re:IsControler(1-tp) then
        Duel.NegateEffect(ev)
    end
end
--------------------------------------------------------------------------





