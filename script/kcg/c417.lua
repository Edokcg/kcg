--コクーン・パーティ
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(Cost.SelfBanish)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end
s.listed_series={SET_CHRYSALIS,0x1f}
s.list={[17955766]=413,[43237273]=415,[54959865]=410,
	[17732278]=411,[89621922]=409,[80344569]=412}

function s.gfilter(c)
	local code=c:GetCode()
	local tcode=s.list[code]
	return tcode and c:IsSetCard(0x1f) and c:IsMonster()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.gfilter,tp,LOCATION_GRAVE,0,nil)
		local ct=s.count_unique_code(g)
		return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.gfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=s.count_unique_code(g)
	if ct==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then return end
    for c in aux.Next(g) do
        local code=c:GetCode()
		local tcode=s.list[code]
		local token=Duel.CreateToken(tp,tcode)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.count_unique_code(g)
	local check={}
	local count=0
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		for i,code in ipairs({tc:GetCode()}) do
			if not check[code] then
				check[code]=true
				count=count+1
			end
		end
	end
	return count
end

function s.thfilter(c)
	return c:ListsArchetype(SET_CHRYSALIS) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.GetFirstMatchingCard(s.thfilter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end