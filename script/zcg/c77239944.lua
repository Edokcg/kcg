--沉默的地狱判官天空龙LVMAX
function c77239944.initial_effect(c)
    c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(77239944,0))
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)	
    e0:SetType(EFFECT_TYPE_QUICK_O)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetHintTiming(0,0x1c0)
    e0:SetRange(LOCATION_HAND)
    e0:SetTarget(c77239944.tg)	
    e0:SetCondition(c77239944.spcon1)
    e0:SetOperation(c77239944.spop1)
    c:RegisterEffect(e0)		
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239944.spcon)
    e1:SetOperation(c77239944.spop)
    c:RegisterEffect(e1)
	
    --cannot special summon
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e2)

    --summon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)

    --immune spell
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c77239944.efilter)
    c:RegisterEffect(e4)
	
    --multi attack
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_EXTRA_ATTACK)
    e5:SetValue(c77239944.value)
    c:RegisterEffect(e5)	
	
    --Indestructibility
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e7)
	
    --Negate
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(77239944,1))	
    e8:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e8:SetType(EFFECT_TYPE_QUICK_O)
    e8:SetCode(EVENT_CHAINING)
    e8:SetRange(LOCATION_MZONE)	
    e8:SetCountLimit(1)	
    e8:SetCondition(c77239944.condition)
    e8:SetTarget(c77239944.target)
    e8:SetOperation(c77239944.operation)
    c:RegisterEffect(e8)	
	
    --recover
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(77239944,2))
    e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e9:SetCategory(CATEGORY_RECOVER)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCountLimit(1)
    e9:SetTarget(c77239944.target1)
    e9:SetOperation(c77239944.operation1)
    c:RegisterEffect(e9)	
end
---------------------------------------------------------------------
function c77239944.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c77239944.spcon1(e,c)
    if c==nil then return true end
    local tp=e:GetHandler():GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetTurnPlayer()~=tp
end
function c77239944.spop1(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
    Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)	
end
function c77239944.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandler():GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c77239944.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
---------------------------------------------------------------------
function c77239944.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
---------------------------------------------------------------------
function c77239944.value(e,c)
    return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)-1
end
---------------------------------------------------------------------
function c77239944.cfilter(c)
    return c:IsOnField()
end
function c77239944.condition(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsChainNegatable(ev) then return false end
    local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
    return ex and tg~=nil and tc+tg:FilterCount(c77239944.cfilter,nil)-tg:GetCount()>0
end
function c77239944.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77239944.desfilter(c)
    return c:IsFaceup()
end
function c77239944.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
---------------------------------------------------------------------
function c77239944.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)>0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c77239944.operation1(e,tp,eg,ep,ev,re,r,rp)
    local rt=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)*2000
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Recover(p,rt,REASON_EFFECT)
end
