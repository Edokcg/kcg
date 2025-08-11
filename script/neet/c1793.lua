--恶魔娘 桃丽丝(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,4,s.lcheck)   
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,0})
	e2:SetCost(s.cost)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,{id,1})
	e3:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
	local e1=e3:Clone()
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and rp==1-tp and e:GetHandler():IsPreviousControler(tp) end)
end
s.listed_series={0x176}
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x176,lc,sumtype,tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsAttribute,1,false,nil,nil,ATTRIBUTE_DARK) end
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsAttribute,1,1,false,nil,nil,ATTRIBUTE_DARK)
	if g:GetFirst():IsSetCard(0x176) then e:SetLabel(1) end
	Duel.Release(g,REASON_COST)
end
function s.thfilter(c)
	return c:IsTrap() and c:IsSSetable()
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x176) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,3,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b3=b1 and b2 and e:GetLabel()==1
	if chk==0 then return b1 or b2 or b3 end
	if chk==0 then return b1 or b2 or b3 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op~=1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		if #g>0 then
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg)
		end
	elseif op==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		if #g>0 then
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg)
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #sc>0 then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end