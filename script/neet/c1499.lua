--化学结合-T2O(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCondition(s.con2)
	e3:SetTarget(s.tg2)
	e3:SetOperation(s.op2)
	c:RegisterEffect(e3)
end
s.listed_series={0x100}
s.listed_names={58071123,85066822,6022371,43017476}
function s.chk(c,sg)
	return c:IsCode(58071123) and sg:IsExists(Card.IsCode,2,c,43017476)
end
function s.costfilter(c,tp)
	return c:IsReleasable() and c:IsCode(43017476,58071123) and (c:IsControler(tp) or c:IsFaceup())
end
function s.costfilter2(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(43017476,58071123)
end
function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(s.chk,1,nil,sg)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp,true):Filter(s.costfilter,nil,tp)
	local g2=Duel.GetMatchingGroup(s.costfilter2,tp,LOCATION_GRAVE,0,nil)
	g:Merge(g2)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon,1,tp,HINTMSG_RELEASE,nil,nil,true)
	local gg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #gg>0 then
		sg:Sub(gg)
		Duel.Remove(gg,POS_FACEUP,REASON_COST)
	end
	Duel.Release(sg,REASON_COST)
end
function s.filter(c,e,tp)
	return (c:IsCode(85066822) or c:IsCode(6022371)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function s.cfilter(c)
	return c:IsReason(REASON_COST) and c:IsMonster()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return eg:IsExists(s.cfilter,1,nil) and re:IsActivated() and rc:IsSetCard(0x100)
end
function s.cfilter2(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsRace(RACE_SEASERPENT) and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.cfilter,nil):Filter(Card.IsAbleToDeck,nil)
	if chk==0 then return #g>0 and Duel.IsPlayerCanDraw(tp,#g) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(s.cfilter,nil):Filter(Card.IsAbleToDeck,nil)
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	Duel.Draw(tp,#g,REASON_EFFECT)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.cfilter2,nil):Filter(Card.IsAbleToDeck,nil)
	if chk==0 then return #g>0 and Duel.IsPlayerCanDraw(tp,#g) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(s.cfilter2,nil):Filter(Card.IsAbleToDeck,nil)
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	Duel.Draw(tp,#g,REASON_EFFECT)
end