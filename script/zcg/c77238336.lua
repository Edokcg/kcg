--太阳神之红魔顿龙
function c77238336.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238336,1))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetCost(c77238336.cost)
    e1:SetOperation(c77238336.indop)
    c:RegisterEffect(e1)

    --Attribute
    local e51=Effect.CreateEffect(c)
    e51:SetType(EFFECT_TYPE_SINGLE)
    e51:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e51:SetCode(EFFECT_ADD_ATTRIBUTE)
    e51:SetRange(LOCATION_MZONE)
    e51:SetValue(ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_WIND)
    c:RegisterEffect(e51)
	
    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(c77238336.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238336.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238336.distg2)
    c:RegisterEffect(e54)	
end
-------------------------------------------------------------------------
function c77238336.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77238336.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end
-------------------------------------------------------------------------
function c77238336.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77238336.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c77238336.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c77238336.filter(c)
    return c:IsSetCard(0xa210) and c:IsDiscardable() and c:IsType(TYPE_MONSTER)
end
function c77238336.indop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetValue(1)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
        c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(c77238336.rdval)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
		--
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(77238336,1))
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_DAMAGE)
		e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e3:SetCondition(c77238336.atkcon)
		e3:SetOperation(c77238336.atkop)
		c:RegisterEffect(e3)
    end
end
function c77238336.rdval(e,re,dam,r,rp,rc)
        if bit.band(r,REASON_BATTLE)~=0 then
        return dam/2
    else return dam end
end
function c77238336.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_BATTLE and ep==tp and Duel.GetAttackTarget()==e:GetHandler()
end
function c77238336.atkop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)	
	e1:SetLabel(ev)
    e1:SetCondition(c77238336.upcon)
    e1:SetOperation(c77238336.upop)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY)
    e:GetHandler():RegisterEffect(e1)
end
function c77238336.upcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c77238336.upop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() then	
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(e:GetLabel())
        e:GetHandler():RegisterEffect(e1)
    end
end

