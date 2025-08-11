--大秘儀之力II-女祭司 (KA)
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
s.listed_names={73206827}
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

	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)

	e1:SetCode(EVENT_CHAIN_SOLVED)

	e1:SetRange(LOCATION_MZONE)

	e1:SetOperation(s.speop)

	e1:SetReset(RESET_EVENT+0x1ff0000)

	c:RegisterEffect(e1)

	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)

end
function s.sp(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsArcana() or c:IsCode(73206827))
end
function s.speop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()

	if not re:IsActiveType(TYPE_SPELL) or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or rp==c:GetControler() then return end

	local val=c:GetFlagEffectLabel(36690018)

	if val==1 then

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)

	local g=Duel.SelectMatchingCard(tp,s.sp,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then

	local tc=g:GetFirst()

	Duel.SendtoHand(tc,nil,REASON_EFFECT)

	Duel.ConfirmCards(1-tp,tc) end

	else

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)

	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then

	local tc=g:GetFirst()

	Duel.SendtoGrave(tc,REASON_EFFECT) end

	end

end