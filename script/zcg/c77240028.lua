--奥西里斯之穿梭器
function c77240028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11400007,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77240028.target)
	e2:SetOperation(c77240028.activate)
	c:RegisterEffect(e2)

	--抗性
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(c77240028.efilter11)
	c:RegisterEffect(e11)
	--disable effect
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_CHAIN_SOLVING)
	e12:SetRange(LOCATION_SZONE)
	e12:SetOperation(c77240028.disop12)
	c:RegisterEffect(e12)
	--disable
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_DISABLE)
	e13:SetRange(LOCATION_SZONE)
	e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e13:SetTarget(c77240028.distg12)
	c:RegisterEffect(e13)
	--self destroy
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_SELF_DESTROY)
	e14:SetRange(LOCATION_SZONE)
	e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e14:SetTarget(c77240028.distg12)
	c:RegisterEffect(e14)
end

function c77240028.filter(c)
	return c:IsFaceup()
end
function c77240028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c77240028.filter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,g:GetCount())
	and Duel.IsExistingMatchingCard(c77240028.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c77240028.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c77240028.efilter11(e,te)
	return te:GetHandler():IsSetCard(0xa60)
end
function c77240028.disop12(e,tp,eg,ep,ev,re,r,rp)
	if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end
function c77240028.distg12(e,c)
	return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
		and c:GetCardTarget():IsContains(e:GetHandler())
end