--奥西里斯之连锁地狱犬者
function c77240033.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c77240033.destg)
	e1:SetOperation(c77240033.desop)
	c:RegisterEffect(e1)

	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c77240033.aclimit)
	c:RegisterEffect(e2)

	--抗性
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(c77240033.efilter11)
	c:RegisterEffect(e11)
	--disable effect
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_CHAIN_SOLVING)
	e12:SetRange(LOCATION_MZONE)
	e12:SetOperation(c77240033.disop12)
	c:RegisterEffect(e12)
	--disable
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_DISABLE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e13:SetTarget(c77240033.distg12)
	c:RegisterEffect(e13)
	--self destroy
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_SELF_DESTROY)
	e14:SetRange(LOCATION_MZONE)
	e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e14:SetTarget(c77240033.distg12)
	c:RegisterEffect(e14)
end
------------------------------------------------------------------------
function c77240033.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77240033.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77240033.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c77240033.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77240033.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77240033.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
------------------------------------------------------------------------
function c77240033.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function c77240033.efilter11(e,te)
	return te:GetHandler():IsSetCard(0xa60)
end
function c77240033.disop12(e,tp,eg,ep,ev,re,r,rp)
	if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end
function c77240033.distg12(e,c)
	return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
		and c:GetCardTarget():IsContains(e:GetHandler())
end