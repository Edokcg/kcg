--殉道者之奇迹的召唤（ZCG）
function c77240218.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77240218.target)
	e1:SetOperation(c77240218.activate)
	c:RegisterEffect(e1)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c77240218.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(0,LOCATION_ONFIELD)
	e12:SetTarget(c77240218.distg9)
	c:RegisterEffect(e12)
end
function c77240218.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function c77240218.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end
function c77240218.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,5) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end
function c77240218.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c77240218.filter(c,e,tp)
	return c:IsLevelAbove(6)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c77240218.activate(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(c77240218.filter,tp,LOCATION_DECK,0,nil,e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c77240218.cfilter,nil)
	if ct>2  and #g2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(77240218,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g2:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end
