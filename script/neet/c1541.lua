--王战之影 甘洛特(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--atk/def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2) 
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,0})
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)   
end
s.listed_series={0x134}
function s.atkfilter(c)
	return c:IsSetCard(0x134) and c:IsMonster() and c:IsFaceup()
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.atkfilter,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*-100
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.gyspfilter(c,e,tp)
	return c:IsSetCard(0x134) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.extraspfilter(c,mg)
	return c:IsXyzSummonable(nil,mg,#mg,#mg)
end
function s.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg and Duel.IsExistingMatchingCard(s.extraspfilter,tp,LOCATION_EXTRA,0,1,nil,sg)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()>4 then ft=ft+1 end
	local mg=Duel.GetMatchingGroup(s.gyspfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local maxct=math.min(ft,mg:GetClassCount(Card.GetCode))
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and maxct>=2 and aux.SelectUnselectGroup(mg,e,tp,2,maxct,s.rescon,0) end
	local sg=aux.SelectUnselectGroup(mg,e,tp,2,maxct,s.rescon,1,tp,HINTMSG_SPSUMMON)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,tp,0)
end
function s.xyzfilter(c,mg,ct)
	return c:IsXyzSummonable(nil,mg,ct,ct)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetCards(e):Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	if #sg>=2 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if #sg>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,sg,ct)
	if ct>=1 and #xyzg>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyzc=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyzc,nil,sg)
	end
end