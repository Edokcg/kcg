--奥利哈刚的符咒 （ZCG）
function c77240264.initial_effect(c)
	--Activate
local e9=Effect.CreateEffect(c)
e9:SetType(EFFECT_TYPE_ACTIVATE)
e9:SetCode(EVENT_FREE_CHAIN)
c:RegisterEffect(e9)
	--recover conversion
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_REVERSE_RECOVER)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(0,1)
	e0:SetValue(1)
	c:RegisterFlagEffect(77240264,RESET_EVENT+RESETS_STANDARD,0,1)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c77240264.spcon)
	e1:SetTarget(c77240264.sptg)
	e1:SetOperation(c77240264.spop)
	c:RegisterEffect(e1)
   --Negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c77240264.condition)
	e5:SetTarget(c77240264.target)
	e5:SetOperation(c77240264.activate)
	c:RegisterEffect(e5)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c77240264.spcon2)
	e3:SetTarget(c77240264.rettg)
	e3:SetOperation(c77240264.retop)
	c:RegisterEffect(e3)
end
function c77240264.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c77240264.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c77240264.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
function c77240264.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp
		and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c77240264.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77240264.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c77240264.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and bit.band(r,REASON_EFFECT)~=0
end
function c77240264.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(77240264)~=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev*2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev*2)
end
function c77240264.spop(e,tp,eg,ep,ev,re,r,rp)
   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end