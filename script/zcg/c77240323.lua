--太阳神之战争的代价(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
		--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
 --disable
	local e53=Effect.CreateEffect(c)
	e53:SetType(EFFECT_TYPE_FIELD)
	e53:SetCode(EFFECT_DISABLE)
	e53:SetRange(LOCATION_SZONE)
	e53:SetTargetRange(0xa,0xa)
	e53:SetTarget(s.distg2)
	c:RegisterEffect(e53)
	--self destroy
	local e54=Effect.CreateEffect(c)
	e54:SetType(EFFECT_TYPE_FIELD)
	e54:SetCode(EFFECT_SELF_DESTROY)
	e54:SetRange(LOCATION_SZONE)
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
function s.desfilter(c)
	return c:GetAttackAnnouncedCount()>0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)   
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,e:GetHandler())
	if #g>0 then
		local hg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_HAND,nil)
		if #hg>0 and  Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then 
			local ct=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGraveAsCost,tp,0,LOCATION_HAND,1,1,nil) 
			Duel.SendtoGrave(ct,REASON_COST)
		else
		Duel.Destroy(g,REASON_EFFECT)
		end
	 end
end