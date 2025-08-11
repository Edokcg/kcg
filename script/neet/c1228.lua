--遗式崩溃(neet)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x3a}
s.listed_names={46159582}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.cfilter(c,dg)
	return c:GetOriginalLevel()>0 and c:IsType(TYPE_RITUAL) and dg:CheckWithSumEqual(Card.GetRankOrLevel,c:GetRankOrLevel(),1,99)
end
function s.dfilter(c,e)
	return c:HasRankOrLevel() and c:IsCanBeEffectTarget()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(s.dfilter,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,s.cfilter,1,nil,dg) and #dg>0
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,s.cfilter,1,1,nil,dg)
	e:SetLabelObject(g:GetFirst())
	local lv=g:GetFirst():GetLevel()
	Duel.Release(g,REASON_COST)
	local sg=dg:SelectWithSumEqual(tp,Card.GetRankOrLevel,lv,1,99)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	local tc=e:GetLabelObject()
	Duel.Destroy(g,REASON_EFFECT)
	if tc:IsSetCard(0x3a) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.thfilter(c)
	return ((c:IsSetCard(0x3a) and c:IsLevelBelow(4)) or c:IsCode(46159582)) and c:IsAbleToHand()
end
function Card.GetRankOrLevel(c)
	if c:IsType(TYPE_XYZ) and c:IsRankAbove(1) then
		return c:GetRank()
	elseif c:HasLevel() then
		return c:GetLevel()
	end
end
function Card.HasRankOrLevel(c)
	if c:IsMonster() then
		return c:GetType()&TYPE_LINK~=TYPE_LINK
			and not c:IsStatus(STATUS_NO_LEVEL)
	elseif c:IsType(TYPE_XYZ) then
		return c:IsRankAbove(1)
	elseif c:IsOriginalType(TYPE_MONSTER) then
		return c:IsStatus(STATUS_NO_LEVEL)
	end
	return false
end