--トゥーン・マスク
--Toon Mask
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.cost)
	-- e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
-- s.listed_names={15259703}

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsType,1,false,nil,nil,TYPE_TOON) end
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsType,1,1,false,nil,nil,TYPE_TOON)
	Duel.Release(g,REASON_COST)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.spfilter(c,e,tp,tc)
	if not (c:IsType(TYPE_TOON) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end
	if c:HasLevel() then return c:IsLevelBelow(c:GetLevel()) end
	if c:HasRank() then return c:IsLevelBelow(c:GetRank()) end
	if c:HasLink() then return c:IsLevelBelow(c:GetLink()) end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local opt=0
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK|LOCATION_HAND,0,1,nil,e,tp,tc)
	local b2=true
	local lv=0
	if tc:HasLevel() then lv=tc:GetLevel() end
	if tc:HasRank() then lv=math.min(lv,tc:GetRank()) end
	if tc:HasLink() then lv=math.min(lv,tc:GetLink()) end
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))
	end
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK|LOCATION_HAND,0,1,1,nil,e,tp,tc)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	else
		local ac=Duel.CreateToken(tp,tc:GetCode(),nil,nil,nil,nil,nil,nil)
		aux.cartoonize(e,tp,Group.FromCards(ac),0,0)
		Duel.SpecialSummon(ac,0,tp,tp,true,false,POS_FACEUP)
		ac:CompleteProcedure()
	end
end