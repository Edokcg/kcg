--沉默的圣石巨神兵LVMAX
function c77239943.initial_effect(c)
    c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(23434538,0))
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
    e0:SetType(EFFECT_TYPE_QUICK_O)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetHintTiming(0,0x1c0)
    e0:SetRange(LOCATION_HAND)
    e0:SetTarget(c77239943.tg)  
    e0:SetCondition(c77239943.spcon1)
    e0:SetOperation(c77239943.spop1)
    c:RegisterEffect(e0)    

    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239943.spcon)
    e1:SetOperation(c77239943.spop)
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
    e4:SetValue(c77239943.efilter)
    c:RegisterEffect(e4)

    --改变效果对象
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239943,0))
    e5:SetType(EFFECT_TYPE_ACTIVATE)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_CHAINING)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c77239943.condition)
    e5:SetTarget(c77239943.target)
    e5:SetOperation(c77239943.activate)
    c:RegisterEffect(e5)

    --destroy
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetDescription(aux.Stringid(77239943,1))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetTarget(c77239943.target1)
    e6:SetOperation(c77239943.operation)
    c:RegisterEffect(e6)
    
    --
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_DAMAGE)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCondition(c77239943.condition1)
    e7:SetOperation(c77239943.operation1)
    c:RegisterEffect(e7)
    
    --Token
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(77239943,2)) 
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1)
    e8:SetTarget(c77239943.target2)
    e8:SetOperation(c77239943.operation2)
    c:RegisterEffect(e8)

    --Indestructibility
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetValue(1)
    c:RegisterEffect(e9)
    local e10=e9:Clone()
    e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e10)
end
---------------------------------------------------------------------
function c77239943.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetChainLimit(aux.FALSE)
end
function c77239943.spcon1(e,c)
    if c==nil then return true end
    local tp=e:GetHandler():GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetTurnPlayer()~=tp
end
function c77239943.spop1(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
    Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP) 
end
function c77239943.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c77239943.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
---------------------------------------------------------------------
function c77239943.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
---------------------------------------------------------------------
function c77239943.condition(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and re:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET)
end
function c77239943.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
        local ftg=te:GetTarget()
        return ftg==nil or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    end
end
function c77239943.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
    Duel.ChangeTargetPlayer(ev,1-p)
end
---------------------------------------------------------------------
function c77239943.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239943.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
---------------------------------------------------------------------
function c77239943.filter(c,tp)
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsType(TYPE_MONSTER)
    and c:GetControler()==1-tp and c:IsLocation(LOCATION_GRAVE)
end
function c77239943.condition1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239943.filter,1,nil,tp)
end
function c77239943.operation1(e,tp,eg,ep,ev,re,r,rp)
    local dam=eg:GetCount()*4000
    Duel.Damage(1-tp,dam,REASON_EFFECT)
end
---------------------------------------------------------------------
function c77239943.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsPlayerCanSpecialSummonMonster(tp,77239939,0,0x5011,4000,4000,10,RACE_DEVINE,ATTRIBUTE_DEVINE) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c77239943.operation2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,77239939,0,0x5011,4000,4000,10,RACE_DEVINE,ATTRIBUTE_DEVINE) then
        local token=Duel.CreateToken(tp,77239939)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
        local token1=Duel.CreateToken(tp,77239939)
        Duel.SpecialSummon(token1,0,tp,tp,false,false,POS_FACEUP)     
    end
end



