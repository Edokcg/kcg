--太阳神之护庭队长(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--coin
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.coincon)
	e3:SetTarget(s.cointg)
	e3:SetOperation(s.coinop)
	c:RegisterEffect(e3)
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
	e52:SetOperation(s.disop2)
	c:RegisterEffect(e52)
	--disable
	local e53=Effect.CreateEffect(c)
	e53:SetType(EFFECT_TYPE_FIELD)
	e53:SetCode(EFFECT_DISABLE)
	e53:SetRange(LOCATION_MZONE)
	e53:SetTargetRange(0xa,0xa)
	e53:SetTarget(s.distg2)
	c:RegisterEffect(e53)
	--self destroy
	local e54=Effect.CreateEffect(c)
	e54:SetType(EFFECT_TYPE_FIELD)
	e54:SetCode(EFFECT_SELF_DESTROY)
	e54:SetRange(LOCATION_MZONE)
	e54:SetTargetRange(0xa,0xa)
	e54:SetTarget(s.distg2)
	c:RegisterEffect(e54)
end
-------------------------------------------------------------------------
function s.disop2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end
function s.distg2(e,c)
	return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
		and c:GetCardTarget():IsContains(e:GetHandler())
end
function s.coincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 then 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetReset(RESET_EVENT+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	e:GetHandler():RegisterEffect(e1)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tp==Duel.GetTurnPlayer() and e:GetHandler():GetLocation()~=LOCATION_ONFIELD
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end