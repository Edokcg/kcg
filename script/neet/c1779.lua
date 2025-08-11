--命运英雄 恐惧小子(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Increase its own ATK
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.adval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e5)	
	--ATK check
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(id)
	c:RegisterEffect(e7)
	--Search 1 Level 8 D.Hero monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,0})
	e3:SetCost(aux.SelfTributeCost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_names={40591390}
s.listed_series={0xc008}
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc008) and not c:IsCode(id) and not c:IsHasEffect(id)
end
function s.adval(e,c)
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then 
		return 0
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		if not tg:IsExists(aux.TRUE,1,e:GetHandler()) then
			g:RemoveCard(e:GetHandler())
			tg,val=g:GetMaxGroup(Card.GetAttack)
		end
		return val
	end
end
function s.thfilter(c)
	return c:IsSetCard(0xc008) and c:IsLevel(8) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsCode(40591390) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		 Duel.SpecialSummon(tc,1,tp,tp,false,false,POS_FACEUP)
	end
end