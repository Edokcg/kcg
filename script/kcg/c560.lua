--奧雷卡爾克斯麥拉克斯 (KA)
local s, id = GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5257687,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(s.deckcon)
	e3:SetCost(Cost.SelfBanish)
	e3:SetTarget(s.decktg)
	e3:SetOperation(s.deckop)
	c:RegisterEffect(e3)
end 
s.listed_series={0x900}

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
		if Duel.GetControl(tc,tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			e1:SetValue(500)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetReset(RESET_EVENT+0x1ff0000)
			e2:SetValue(500)
			tc:RegisterEffect(e2)
		elseif not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end

function s.deckcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.filter(c,tp)
	return c:IsSetCard(0x900) and c:IsType(TYPE_SPELL) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.decktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function s.deckop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26964762,3))
	local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(26964762,3))
	local g2=Duel.SelectMatchingCard(1-tp,s.filter,1-tp,LOCATION_DECK,0,1,1,nil,1-tp)
	local tc1=g1:GetFirst()
	local tc2=g2:GetFirst()
	if tc1 then
		local te=tc1:GetActivateEffect()
		if te and te:IsActivatable(tp,true) then
			Duel.Hint(HINT_CARD,tp,tc1:GetOriginalCode())
			Duel.Hint(HINT_CARD,1-tp,tc1:GetOriginalCode())
			Duel.BreakEffect()
			Duel.Activate(te)
		end
	end
	if tc2 then
		local te=tc2:GetActivateEffect()
		if te and te:IsActivatable(tp,true) then
			Duel.Hint(HINT_CARD,tp,tc2:GetOriginalCode())
			Duel.Hint(HINT_CARD,1-tp,tc2:GetOriginalCode())
			Duel.BreakEffect()
			Duel.Activate(te)
		end
	end
end
