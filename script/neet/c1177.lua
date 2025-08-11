--暗黑界的异型 葛雷(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Link summon procedure
	Link.AddProcedure(c,s.matfilter,2,2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(function(e)return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)end)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCost(Cost.SelfRelease)
	e0:SetOperation(s.immop)
	c:RegisterEffect(e0)
end
s.listed_series={SET_DARK_WORLD}
function s.matfilter(c,scard,sumtype,tp)
	return c:IsRace(RACE_FIEND,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,scard,sumtype,tp)
end
function s.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_DARK_WORLD)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.drfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	e:SetLabel(ct)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,ct)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=e:GetLabel()
	if Duel.Draw(p,d,REASON_EFFECT)==d then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,d,d,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.filter(c)
	return c:IsRace(SET_DARK_WORLD) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil)and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_FIEND) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,Card.IsRace,1,1,REASON_EFFECT+REASON_DISCARD,nil,RACE_FIEND)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsRace(RACE_WARRIOR) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(1595)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end