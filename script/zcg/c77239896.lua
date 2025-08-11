--地狱之幻魔皇 拉比艾尔(ZCG)
function c77239896.initial_effect(c)
    c:EnableReviveLimit()
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCondition(c77239896.atkcon)
    e1:SetOperation(c77239896.atkop)
    c:RegisterEffect(e1)
    local e01=e1:Clone()
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e01)
	
    --cannot be battle target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetValue(c77239896.tg)
    c:RegisterEffect(e2)	
	
	--direct attack
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239896,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239896.cost)
    e3:SetOperation(c77239896.operation)
    c:RegisterEffect(e3)

    --Direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c77239896.dircon)
	c:RegisterEffect(e4)
end
-------------------------------------------------------------------------------------
function c77239896.atkfilter(c,e,tp)
    return c:IsControler(tp) and c:IsFaceup()
end
function c77239896.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239896.atkfilter,1,nil,nil,1-tp)
end
function c77239896.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c77239896.atkfilter,nil,e,1-tp)
    local c=e:GetHandler()
    local tc=g:GetFirst()
    while tc do
        local atk=tc:GetBaseAttack()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(atk)
        c:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
-------------------------------------------------------------------------------------
function c77239896.tg(e,c)
    return c~=e:GetHandler()
end
-------------------------------------------------------------------------------------
function c77239896.cfilter(c)
    return c:IsCode(69890967) and c:IsAbleToRemoveAsCost()
end
function c77239896.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239896.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239896.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77239896.operation(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e:GetHandler():RegisterEffect(e1)
end

function c77239896.cfilter1(c)
	return c:IsFaceup() and c:IsCode(69890967)
end
function c77239896.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c77239896.cfilter1,tp,LOCATION_REMOVED,0,1,nil)
end