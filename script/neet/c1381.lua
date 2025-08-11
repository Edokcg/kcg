--融合之圣刻印(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),s.matfilter,s.fextra,s.extraop,nil,nil,nil,nil,nil,nil,nil,nil,nil,s.extratg)
	c:RegisterEffect(e1)   
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={0x69}
function s.matfilter(c)
	return c:IsReleasable() or (c:IsLocation(LOCATION_DECK) and c:IsAbleToGrave())
end
function s.checkmat(tp,sg,fc)
	return fc:IsSetCard(0x69) and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.dffilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON) and c:IsAbleToGrave()
end
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(s.dffilter,tp,LOCATION_DECK,0,nil),s.checkmat
end
function s.extraop(e,tc,tp,sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	if #rg>0 then
		Duel.SendtoGrave(rg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(rg)
	end
	Duel.Release(sg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	sg:Clear()
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end
function s.thfilter(c)
	return c:IsSetCard(0x69) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(id) and c:IsAbleToHand()
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