--海上仙鹤
function c77239594.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
    e1:SetValue(500)
    c:RegisterEffect(e1)
	
    --atkdown
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
    e2:SetValue(-400)
    c:RegisterEffect(e2)
	
    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239594,0))
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239594.cost)
    e3:SetTarget(c77239594.target)
    e3:SetOperation(c77239594.operation)
    c:RegisterEffect(e3)		
end
-----------------------------------------------------------------
function c77239594.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler()) end
    local sg=Duel.SelectReleaseGroup(tp,nil,1,1,e:GetHandler())
    Duel.Release(sg,REASON_COST)
end
function c77239594.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local dam=e:GetHandler():GetAttack()/2
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77239594.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end

