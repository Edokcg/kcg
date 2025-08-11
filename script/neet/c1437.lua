--捕食植物 九头蛇大花草(neet)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
s.listed_series={0x46}
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_DARK),tp,LOCATION_MZONE,0,nil)+1
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToGrave,nil)>0
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.thfilter(c)
	return c:IsSetCard(0x46) and c:IsAbleToGrave()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsAttribute,ATTRIBUTE_DARK),tp,LOCATION_MZONE,0,nil)+1
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<dc then return end
	Duel.ConfirmDecktop(tp,dc)
	local dg=Duel.GetDecktopGroup(tp,dc):Filter(s.thfilter,nil)
	if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=dg:Select(tp,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoGrave(tc,REASON_EFFECT|REASON_EXCAVATE)
			local ae=tc:GetActivateEffect()
			if tc:GetLocation()==LOCATION_GRAVE and ae then
				local e1=Effect.CreateEffect(tc)
				e1:SetDescription(ae:GetDescription())
				e1:SetType(EFFECT_TYPE_IGNITION)
				e1:SetCountLimit(1)
				e1:SetRange(LOCATION_GRAVE)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_CONTROL|RESET_PHASE|PHASE_END|RESET_SELF_TURN&~RESET_TOFIELD)
				e1:SetCondition(s.spellcon)
				e1:SetTarget(s.spelltg)
				e1:SetOperation(s.spellop)
				tc:RegisterEffect(e1)
			end
		end
	end
	Duel.ShuffleDeck(tp)
end
function s.spellcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=e:GetHandler():GetActivateEffect()
	local ftg=ae:GetTarget()
	if chk==0 then
		return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function s.spellop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_FUSION
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
