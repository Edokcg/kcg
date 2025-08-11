--魔弹射手 刀锋(neet)
local s,id=GetID()
function s.initial_effect(c)
	--"Magical Musket" Spell/Trap cards can be activated from the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,SET_MAGICAL_MUSKET))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--Draw 1 card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,0})
	e3:SetCondition(s.tdcon)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)	
end

s.listed_series={SET_MAGICAL_MUSKET}
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.GetCurrentPhase()&PHASE_DAMAGE+PHASE_DAMAGE_CAL~=0 or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return c:IsColumn(seq,p,LOCATION_SZONE)
end
function s.filter(c)
	return c:IsSetCard(SET_MAGICAL_MUSKET) and c:IsAbleToDeck()
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,2))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetTarget(s.disable)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function s.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT) and not e:GetHandler():GetColumnGroup():IsContains(c)
end