--究极奥利哈刚之神
function c77239292.initial_effect(c)
    c:EnableReviveLimit()
    --damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239292,0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c77239292.cost)
    e1:SetTarget(c77239292.target)
    e1:SetOperation(c77239292.operation)
    c:RegisterEffect(e1)

    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239292,1))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77239292.cost1)
    e2:SetTarget(c77239292.target1)
    e2:SetOperation(c77239292.operation1)
    c:RegisterEffect(e2)	
	
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetDescription(aux.Stringid(77239292,2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239292.cost2)
    e3:SetTarget(c77239292.target2)
    e3:SetOperation(c77239292.operation2)
    c:RegisterEffect(e3)	
	
    --unaffectable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(c77239292.efilter)
    c:RegisterEffect(e4)
	
	--玩家不会受到战斗伤害
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(1,0)
    e5:SetValue(0)
    c:RegisterEffect(e5)

    --玩家不会受到效果伤害
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CHANGE_DAMAGE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(1,0)
    e6:SetValue(c77239292.damval)
    c:RegisterEffect(e6)
end

function c77239292.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 then return 0 end
    return val
end

function c77239292.cfilter(c)
    return c:IsFaceup() and c:IsCode(77239230)
end
function c77239292.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c77239292.cfilter,1,nil) end
    local sg=Duel.SelectReleaseGroup(tp,c77239292.cfilter,1,1,nil)
    e:SetLabel(sg:GetFirst():GetAttack())
    Duel.Release(sg,REASON_COST)
end
function c77239292.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c77239292.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
-----------------------------------------------------------------
function c77239292.filter(c)
    return c:IsAbleToGraveAsCost()
end
function c77239292.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239292.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c77239292.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
    if g:GetCount()>0 then
        Duel.HintSelection(g)	
        Duel.Release(g,REASON_COST)
    end
end
function c77239292.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(4000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
end
function c77239292.operation1(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
-----------------------------------------------------------------
function c77239292.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,100)
    else Duel.PayLPCost(tp,100) end
end
function c77239292.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,c) end
    local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239292.operation2(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,e:GetHandler())
    Duel.Destroy(sg,REASON_EFFECT)
end
-----------------------------------------------------------------
function c77239292.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end

