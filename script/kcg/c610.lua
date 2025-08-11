--Numeron typhoon
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.con)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x14b}
s.listed_names={41418852}

function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x14b)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil) 
end
function s.filter(c)
	return aux.TRUE
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,c) end
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.filter2(c)
	return c:IsCode(41418852) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,e:GetHandler())
	if Duel.Destroy(sg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end 
	end
end
