--ヒーローズ・ギルド
--Hero's Guild
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.IsPlayerCanDiscardDeck(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not Duel.IsPlayerCanDiscardDeck(tp,1)
		or not Duel.IsPlayerCanDiscardDeck(1-tp,1) then return end
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
    e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
    e2:SetLabelObject(e)
	e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e2)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local te=e:GetLabelObject()
	if chk==0 then return Duel.IsExistingMatchingCard(s.warrior,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,te) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,PLAYER_ALL,LOCATION_GRAVE)
end
function s.warrior(c,te)
    return c:IsRace(RACE_WARRIOR) and c:IsAbleToHand() and c:IsReasonEffect(te)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    local g=Duel.GetMatchingGroup(s.warrior,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,te)
    if #g<1 then return end
    local toHand=false
    for tc in aux.Next(g) do
		Duel.HintSelection(tc)
        if Duel.SelectYesNo(tc:GetControler(),aux.Stringid(id,0)) then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tc:GetControler(),tc)
            toHand=true
        end
    end
    if toHand then
        Duel.Destroy(e:GetHandler(s),REASON_EFFECT)
    end
end