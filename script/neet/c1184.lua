--秘仪之力10-命运之轮(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FAIRY),2,nil,s.matcheck)
	--Toss a coin and apply appropriate effect, base on result
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.cointg)
	e3:SetOperation(s.coinop)
	c:RegisterEffect(e3)
	--change coin
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(s.coincon1)
	e3:SetCost(Cost.SelfBanish)
	e3:SetOperation(s.coinop1)
	c:RegisterEffect(e3)
end
s.toss_coin=true
s.listed_series={SET_ARCANA_FORCE}
function s.matcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,SET_ARCANA_FORCE,lc,sumtype,tp)
end
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	s.arcanareg(c,Arcana.TossCoin(c,tp),e,tp)
end
function s.rfilter(c)
	return c:IsSetCard(SET_ARCANA_FORCE) and c:IsMonster() and c:IsAbleToGrave()
end
function s.arcanareg(c,coin,e,tp)
	--coin effect
	local regc=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil):GetFirst()
	if not regc then return end
	Duel.SendtoGrave(regc,REASON_EFFECT)
	local regfun=regc.arcanareg
	if not regfun then return end  
	regfun(c,coin)
	--[[c:RegisterFlagEffect(99189322,RESET_EVENT|RESETS_STANDARD_DISABLE|RESET_PHASE|PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetOperation(s.rec_effect)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.rec_effect(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffect(99189322)==0 or tc:GetFlagEffect(CARD_REVERSAL_OF_FATE)==0 then return end
	local regfun=tc.arcanareg
	if not regfun then return end
	local val=Arcana.GetCoinResult(tc)
	tc:ResetEffect(RESET_DISABLE,RESET_EVENT)
	regfun(tc,val)--]]
end
function s.coincon1(e,tp,eg,ep,ev,re,r,rp)
	local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	if ex  then
		e:SetLabelObject(re)
		return true
	else return false end
end
function s.coinop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_COIN_NEGATE)
	e1:SetCondition(s.coincon2)
	e1:SetOperation(s.coinop2)
	e1:SetLabel(ev)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.coincon2(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject() and Duel.GetCurrentChain()==e:GetLabel()
end
function s.coinop2(e,tp,eg,ep,ev,re,r,rp)
	local res={}
	for i=1,ev do
		table.insert(res,COIN_HEADS)
	end
	Duel.SetCoinResult(table.unpack(res))
end