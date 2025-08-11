--闪斩机 圆幂力（neet）
Duel.LoadScript("neet.lua")
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Add to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,{id,1})
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_series={0x132}
function s.filter(c,e,tp,g)
	return c:IsSetCard(0x132) and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_ONFIELD,1,c,e,tp,g,c)
end
function s.filter2(c,e,tp,g,tc)
	local a,b=c:GetSequence(),tc:GetSequence()
	if not g:IsContains(c) or not c:IsCanBeEffectTarget(e) then return end
	return math.abs(tc:GetColumns(tp)-c:GetColumns(tp))>1 and not ((a==5 or a==6) and (b==5 or b==6))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local c=e:GetHandler()
		local g=c:GetColumnGroup()
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil,e,tp,g)
	end
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,0,LOCATION_ONFIELD,1,1,g1,e,tp,g,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
end
function s.cfilter(c,tp,seq,seq2)
	return (seq>c:GetColumns(tp) and c:GetColumns(tp)>seq2 ) or (seq<c:GetColumns(tp) and c:GetColumns(tp)<seq2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g~=2 then return end
	local tc=g:GetFirst()
	local tc2=g:GetNext()
	local seq=tc:GetColumns(tp)
	local seq2=tc2:GetColumns(tp)
	local a,b=tc:GetSequence(),tc2:GetSequence()
	if math.abs(seq-seq2)<=1 then return end
	if (a==5 or a==6) and (b==5 or b==6) then return end
	local loc,loc2=0,0
	if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) then loc=loc|LOCATION_MZONE end
	if tc:IsLocation(LOCATION_SZONE) and tc:IsControler(tp) then loc=loc|LOCATION_ONFIELD end
	if tc2:IsLocation(LOCATION_MZONE) and tc2:IsControler(1-tp) then loc2=loc2+LOCATION_MZONE end
	if tc2:IsLocation(LOCATION_SZONE) and tc2:IsControler(1-tp) then loc2=loc2|LOCATION_ONFIELD end
	local sg=Duel.GetMatchingGroup(s.cfilter,tp,loc,loc2,nil,tp,seq,seq2)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(#sg*1000)
	c:RegisterEffect(e1)
	for nc in aux.Next(sg) do
		nc:NegateEffects(c,RESET_PHASE|PHASE_END,true)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and rp==1-tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.thfilter(c)
	return c:IsSetCard(0x132) and c:IsMonster() and c:IsAbleToHand()
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