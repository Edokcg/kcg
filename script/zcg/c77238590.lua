--神兵裁决(ZCG)
function c77238590.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
   -- e2:SetCondition(c77238590.con)
	e2:SetTarget(c77238590.target)
	e2:SetOperation(c77238590.activate)
	c:RegisterEffect(e2)
end

--[[function c77239564.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.AnnounceType(tp)
	e:SetLabel(op)
end
function c77239564.activate(e,tp,eg,ep,ev,re,r,rp)
	local ty=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetOperation(c77239564.desop)
	e1:SetLabel(ty)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e1,tp)
end
function c77238590.desop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	local win=0
	local tc=hg:GetFirst()
	local opt=e:GetLabel()
	if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	Duel.ShuffleHand(ep)
end

function c77238590.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa220) and c:IsType(TYPE_MONSTER)
end]]

function c77238590.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp --and Duel.IsExistingMatchingCard(c77238590.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c77238590.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	Duel.SetTargetParam(Duel.SelectOption(tp,70,71,72))
end
function c77238590.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<0 then return end
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.BreakEffect()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	while tc do
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if not ((opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP))) then
			break
		end
		g=Duel.GetDecktopGroup(tp,1)
		tc=g:GetFirst()
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	end
end