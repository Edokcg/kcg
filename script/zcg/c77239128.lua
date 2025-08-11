--白龙之魔导骑士(ZCG)
function c77239128.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,89631139,46986414,false,false)
	Fusion.AddContactProc(c,c77239128.contactfil,c77239128.contactop,c77239128.splimit)
	
	--破坏
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCost(c77239128.cost)
	e3:SetTarget(c77239128.target)
	e3:SetOperation(c77239128.activate)
	c:RegisterEffect(e3)
	
	--结束阶段特殊召唤
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c77239128.discon)   
	e4:SetTarget(c77239128.target1)
	e4:SetOperation(c77239128.operation)
	c:RegisterEffect(e4)
end
c77239128.listed_names={89631139,46986414}
-------------------------------------------------------------------------
function c77239128.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c77239128.spfilter(c,code)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsFusionCode(code)
end
--------------------------------------------------------------------------
function c77239128.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c77239128.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239128.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77239128.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c77239128.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239128.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77239128.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
--------------------------------------------------------------------------
function c77239128.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c77239128.sfilter1(c,e,tp)
	return c:IsCode(89631139) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239128.sfilter2(c,e,tp)
	return c:IsCode(46986414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239128.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239128.sfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c77239128.sfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239128.operation(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c77239128.sfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c77239128.sfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c77239128.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
end
function c77239128.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
end
function c77239128.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end