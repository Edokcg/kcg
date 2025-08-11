--呪われし竜－カース・オブ・ドラゴン
--Curse of Dragon, the Cursed Dragon
local s,id=GetID()
function s.initial_effect(c)
    local e01=Effect.CreateEffect(c)
	e01:SetDescription(aux.Stringid(id,2))
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_SUMMON_PROC)
	e01:SetRange(LOCATION_HAND)
	e01:SetCondition(s.notribcon)
	c:RegisterEffect(e01)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e02:SetCode(EFFECT_CHANGE_CODE)
	e02:SetRange(LOCATION_MZONE|LOCATION_GRAVE)
	e02:SetValue(28279543)
	c:RegisterEffect(e02)
	--Add 1 Spell/Trap from the Deck to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Negate the effects of monsters
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(function(e) return e:GetHandler():IsReason(REASON_BATTLE|REASON_EFFECT) end)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_GAIA_CHAMPION,CARD_SHINING_SARCOPHAGUS,28279543}

function s.notribcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_SHINING_SARCOPHAGUS),tp,LOCATION_ONFIELD,0,1,nil)
end

function s.thfilter(c)
	return c:ListsCode(CARD_GAIA_CHAMPION,CARD_SHINING_SARCOPHAGUS) and c:IsSpellTrap() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.discfilter(c,tp)
	return c:IsFaceup() and (c:IsCode(CARD_GAIA_CHAMPION) or c:ListsCode(CARD_SHINING_SARCOPHAGUS)) and Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function s.disfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and c:IsNegatableMonster()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.discfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.discfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.discfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsFaceup() and tc:IsRelateToEffect(e)) then return end
	local g=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	for hc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		hc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		hc:RegisterEffect(e2)
		if hc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			hc:RegisterEffect(e3)
		end
	end
end
