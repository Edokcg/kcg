--大秘儀之力IX-隱者 (KA)
local s,id=GetID()
function s.initial_effect(c)
	 --coin
	local e1=Effect.CreateEffect(c)

	e1:SetDescription(aux.Stringid(8396952,0))

	e1:SetCategory(CATEGORY_COIN)

	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)

	e1:SetCode(EVENT_SUMMON_SUCCESS)

	e1:SetTarget(s.cointg)

	e1:SetOperation(s.coinop)

	c:RegisterEffect(e1)

	local e2=e1:Clone()

	e2:SetCode(EVENT_SPSUMMON_SUCCESS)

	c:RegisterEffect(e2)

	local e3=e1:Clone()

	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)

	c:RegisterEffect(e3)

end
s.listed_series={0x5}
s.toss_coin=true

function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then return true end

	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)

end

function s.coinop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()

	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end

	local res=0

	if c:IsHasEffect(73206827) then

		res=1-Duel.SelectOption(tp,60,61)

	else res=Duel.TossCoin(tp,1) end

	s.arcanareg(c,res)

end

function s.arcanareg(c,coin)

	--disable effect

	local e1=Effect.CreateEffect(c)

	e1:SetType(EFFECT_TYPE_IGNITION)

	e1:SetRange(LOCATION_MZONE)

	e1:SetCountLimit(1)

	e1:SetOperation(s.speop)

	e1:SetReset(RESET_EVENT+0x1ff0000)

	c:RegisterEffect(e1)

	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)

end

function s.speop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()

	Duel.ConfirmDecktop(tp,2)

	local g=Duel.GetDecktopGroup(tp,2)

	if g:GetCount()<2 then return end

	local val=c:GetFlagEffectLabel(36690018)

	if val==1 then

		local ag=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)

		if ag:GetCount()==1 then

		local agc=ag:GetFirst()

		Duel.SendtoHand(agc,nil,REASON_EFFECT)

		Duel.ConfirmCards(1-tp,agc)

		g:RemoveCard(agc) end 

		local tc=g:GetFirst()

		while tc do

		Duel.MoveSequence(tc,1)

		tc=g:GetNext() end

	end

	if val==0 then

		local ag=g:Filter(s.filter,nil)

		if ag:GetCount()>0 then

		Duel.SendtoGrave(ag,REASON_EFFECT)

		local ag2=Duel.GetOperatedGroup()

		g:Sub(ag2) end 

		local tc=g:GetFirst()

		while tc do

		Duel.MoveSequence(tc,1)

		tc=g:GetNext() end

	end

end

function s.filter(c)

	return c:IsAbleToGrave() and c:IsSetCard(0x5) and c:IsType(TYPE_MONSTER)

end
