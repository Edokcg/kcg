--奧雷卡爾克斯邪魔導 (KA)
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x900),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.decktg)
	e1:SetOperation(s.deckop)
	c:RegisterEffect(e1)
	--lp set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(s.slop)
	c:RegisterEffect(e2)
end
s.listed_series={0x900}
s.material_setcode={0x900}
s.listed_names={10}

function s.filter(c,tp)
	return c:IsCode(10) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.decktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_DECK)
end
function s.deckop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	if tc1 then
		Duel.ShuffleDeck(1-tp)
		Duel.SendtoDeck(tc1,1-tp,SEQ_DECKTOP,REASON_EFFECT)
		Duel.ConfirmDecktop(1-tp,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCode(EVENT_DRAW)
		e1:SetRange(LOCATION_HAND)
		e1:SetCost(s.spcost)
		e1:SetOperation(s.spop1)
		tc1:RegisterEffect(e1)
	end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=c:GetActivateEffect()
	if te and te:IsActivatable(tp,true) then
		Duel.Hint(HINT_CARD,tp,c:GetOriginalCode())
		Duel.Hint(HINT_CARD,1-tp,c:GetOriginalCode())
		Duel.BreakEffect()
		Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp)
	end
end

function s.slop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp) then return end
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()<1 then return end
	local tc=g:GetFirst()
	local te=tc:GetActivateEffect()
	if te and te:IsActivatable(tp,true) then
		Duel.Hint(HINT_CARD,tp,tc:GetOriginalCode())
		Duel.Hint(HINT_CARD,1-tp,tc:GetOriginalCode())
		Duel.BreakEffect()
		Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
	end
end