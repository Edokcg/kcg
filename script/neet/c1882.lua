--时械域(neet)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)  
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,5))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
end
s.listed_series={0x4a}
s.listed_names={9409625,36894320,72883039}
function s.tdfilter(c)
	return (c:IsCode({9409625,36894320,72883039}) or (c:IsSetCard(0x4a) and c:IsMonster())) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(s.tdfilter),p,LOCATION_HAND+LOCATION_GRAVE,0,1,99,nil)
	if #g==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,#g,REASON_EFFECT)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
end
function s.filter(c,tp,code)
	return c:IsCode(code) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
	if c:IsOnField() or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp,9409625)
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp,36894320)
	local b3=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp,72883039)
	if (b1 or b2 or b3) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.BreakEffect()
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,1)},
			{b2,aux.Stringid(id,2)},
			{b3,aux.Stringid(id,3)})
			local code=(op==1 and 9409625) or (op==2 and 36894320) or 72883039
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tp,code):GetFirst()
			if tc then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
	end
end