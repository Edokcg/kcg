--黑暗根源(ZCG)
function c77239028.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
	--提升攻防
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)	
	e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1) 	
    e2:SetOperation(c77239028.adop)
	c:RegisterEffect(e2)
	
    --不能发动魔法卡
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,1)
    e3:SetValue(c77239028.filter)
    c:RegisterEffect(e3)
	
	--丢卡
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_HANDES)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c77239028.damcon)
	e5:SetTarget(c77239028.hdtg)
	e5:SetOperation(c77239028.hdop)
	c:RegisterEffect(e5)

    --伤害
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DAMAGE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_TO_GRAVE)
    e6:SetCondition(c77239028.condition)
    e6:SetTarget(c77239028.target)
    e6:SetOperation(c77239028.operation)
    c:RegisterEffect(e6)	
end
---------------------------------------------------------
function c77239028.adfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c77239028.adop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77239028.adfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        tc=g:GetNext()		
    end
end
---------------------------------------------------------
function c77239028.filter(e,re,tp)
    return re:GetHandler():IsType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
---------------------------------------------------------
function c77239028.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239028.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():ResetFlagEffect(77239028)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,1)
end
function c77239028.hdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():RegisterFlagEffect(77239028,RESET_EVENT+0x1fe0000,0,0)
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
	end
end
---------------------------------------------------------
function c77239028.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c77239028.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,500)
end
function c77239028.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(tp,500,REASON_EFFECT,true)
    Duel.Damage(1-tp,500,REASON_EFFECT,true)
    Duel.RDComplete()
end

