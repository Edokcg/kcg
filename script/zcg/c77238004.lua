--地缚神 凯特菲斯(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 --direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(s.dircon)
	c:RegisterEffect(e5)
		--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(s.pencoon)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)
end
function s.pencoon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousPosition(POS_FACEUP)
end
function s.filter(c)
	return c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_SZONE,0,1,nil)  and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_SZONE,0,nil)
	local sgg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.Destroy(sgg,REASON_EFFECT)
end

function s.dirfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function s.dircon(e)
	return Duel.IsExistingMatchingCard(s.dirfilter1,e:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
end