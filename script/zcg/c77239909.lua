--究极的幻神(ZCG)
function c77239909.initial_effect(c)
	c:EnableReviveLimit()
	
    --unaffectable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c77239909.efilter)
    c:RegisterEffect(e1)
	
    --lose
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetOperation(c77239909.winop)
    c:RegisterEffect(e2)

    --除外
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239909,0))
    e3:SetCategory(CATEGORY_REMOVE)	
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e3:SetCost(c77239909.cost)
    e3:SetTarget(c77239909.target)
    e3:SetOperation(c77239909.operation)
    c:RegisterEffect(e3)

    --除外
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239909,1))
    e4:SetCategory(CATEGORY_REMOVE)	
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e4:SetCost(c77239909.cost)
    e4:SetTarget(c77239909.target1)
    e4:SetOperation(c77239909.operation1)
    c:RegisterEffect(e4)

    --除外
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239909,2))
    e5:SetCategory(CATEGORY_REMOVE)	
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e5:SetCost(c77239909.cost)
    e5:SetTarget(c77239909.target2)
    e5:SetOperation(c77239909.operation2)
    c:RegisterEffect(e5)

    --
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetOperation(c77239909.op)
    c:RegisterEffect(e6)
end
----------------------------------------------------------------------------------------
function c77239909.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
----------------------------------------------------------------------------------------
function c77239909.winop(e,tp,eg,ep,ev,re,r,rp)
    local WIN_REASON_CREATORGOD=0x13
    Duel.Win(1-tp,WIN_REASON_CREATORGOD)
end
----------------------------------------------------------------------------------------
function c77239909.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function c77239909.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c77239909.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    local dg=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if dg>0 then
	    Duel.Damage(1-tp,dg*500,REASON_EFFECT)
	end
end
----------------------------------------------------------------------------------------
function c77239909.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c77239909.operation1(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
    local dg=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if dg>0 then
	    Duel.Damage(1-tp,dg*500,REASON_EFFECT)
	end
end
----------------------------------------------------------------------------------------
function c77239909.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c77239909.operation2(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    local dg=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if dg>0 then
	    Duel.Damage(1-tp,dg*500,REASON_EFFECT)
	end
end
----------------------------------------------------------------------------------------
function c77239909.op(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():CopyEffect(10000000,1)
    e:GetHandler():CopyEffect(10000010,1)
    e:GetHandler():CopyEffect(10000020,1)
end