--奥利哈刚 埃瑞克特
function c77239213.initial_effect(c)
    --atklimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    c:RegisterEffect(e1)
	
	--
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    c:RegisterEffect(e2)
	
    --control
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
    c:RegisterEffect(e3)

    --[[atk up
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239213,0))
    e4:SetCategory(CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCost(c77239213.adcost)
    e4:SetOperation(c77239213.adop)
    c:RegisterEffect(e4)]]
	
	--攻击力
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239213,0))
    e4:SetCategory(CATEGORY_HANDES+CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c77239213.target1)
    e4:SetOperation(c77239213.operation1)
    c:RegisterEffect(e4)
	
    --damage
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239213,1))
    e5:SetCategory(CATEGORY_DAMAGE)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCost(c77239213.cost)
    e5:SetTarget(c77239213.tg)
    e5:SetOperation(c77239213.op)
    c:RegisterEffect(e5)	
end

--[[function c77239213.cfilter(c)
    return c:IsSetCard(0xa50) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c77239213.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239213.cfilter,tp,LOCATION_HAND,0,1,nil) end
    local g=Duel.GetMatchingGroup(c77239213.cfilter,tp,LOCATION_HAND,0,nil)
    local ct=Duel.DiscardHand(tp,c77239213.cfilter,1,g:GetCount(),REASON_COST+REASON_DISCARD)
    e:SetLabel(ct:GetCount())
end
function c77239213.adop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(e:GetLabel()*1000)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
    end
end]]

function c77239213.filter(c)
    return c:IsSetCard(0xa50) and c:IsDiscardable()
end
function c77239213.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239213.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetTargetPlayer(tp)	
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
end
function c77239213.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)	
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)	
    local g=Duel.SelectMatchingCard(p,c77239213.filter,p,LOCATION_HAND,0,1,63,nil)
    local ct=Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	if ct>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(ct*1000)
        e1:SetReset(RESET_EVENT+0x1fe0000)		
        c:RegisterEffect(e1)	
	end
end
function c77239213.filter1(c)
    return c:IsSetCard(0xa50)
end
function c77239213.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77239213.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return true end
	local dam=c:GetPreviousAttackOnField()
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77239213.op(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end