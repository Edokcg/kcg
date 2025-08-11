--邪神·欧贝利斯克之巨神兵
function c77239932.initial_effect(c)
    c:EnableReviveLimit()
	
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c77239932.val)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
	
	--unaffectable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(c77239932.efilter)
    c:RegisterEffect(e4)

    --ATKMAX
    local e6=Effect.CreateEffect(c)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetDescription(aux.Stringid(77239932,0))
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCost(c77239932.cost)
    e6:SetOperation(c77239932.atkop)
    c:RegisterEffect(e6)	
	
    --destroy
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77239932,1))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c77239932.cost)
    e7:SetTarget(c77239932.destg)
    e7:SetOperation(c77239932.desop)
    c:RegisterEffect(e7)	
end
-------------------------------------------------------------------
function c77239932.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
-------------------------------------------------------------------
function c77239932.val(e,c)
    local g=Duel.GetMatchingGroup(c77239932.vfilter,c:GetControler(),LOCATION_REMOVED,0,c)
    return g:GetSum(Card.GetAttack)+1000
end
function c77239932.vfilter(c)
    return c:IsCode(10000000) or c:IsCode(10000010) or c:IsCode(10000020)
	or c:IsCode(513000134) or c:IsCode(513000135) or c:IsCode(513000136)
end
-------------------------------------------------------------------
function c77239932.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,2,e:GetHandler()) end
    local g=Duel.SelectReleaseGroup(tp,nil,2,2,e:GetHandler())
    Duel.Release(g,REASON_COST)
end
function c77239932.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239932.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(g,REASON_EFFECT)
	Duel.Damage(1-tp,4000,REASON_EFFECT)
end
-------------------------------------------------------------------
function c77239932.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INF_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end

