--ダークネスソウル
--Umbral Soul
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetTarget(s.atg)
	e0:SetOperation(s.aop)
	c:RegisterEffect(e0)

	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetCategory(CATEGORY_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(s.adtg)
	e7:SetOperation(s.adop)
	c:RegisterEffect(e7)

	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_DISABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetCondition(s.discondition)
	e8:SetTarget(s.distarget)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e9)
	local e10=e8:Clone()
	e10:SetCode(EFFECT_CANNOT_DISABLE_FLIP_SUMMON)
	c:RegisterEffect(e10)
	local e11=e8:Clone()
	e11:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e11)
	local e12=e8:Clone()
	e12:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	c:RegisterEffect(e12)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.adtg2)
	e5:SetOperation(s.adop2)
	c:RegisterEffect(e5)
end
s.listed_series={0x316}

function s.afilter(c)
	return c:IsSetCard(0x316) and c:IsMonster() and c:IsAbleToHand()
end
function s.atg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.afilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.aop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local setg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.afilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #setg>0 then
		Duel.SendtoHand(setg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,setg)
	end
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function s.filter(c)
	return (c:IsFacedown() or c:GetAttribute()~=ATTRIBUTE_DARK)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

function s.adfilter(c,tp)
	if not c:IsSetCard(0x316) or c:IsLevelBelow(4) then return false end
	local chk=false
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_RELEASE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local eff={}
	local ae={c:IsHasEffect(EFFECT_UNSUMMONABLE_CARD)}
	for _,te in ipairs(ae) do
		table.insert(eff,te)
		te:Reset()
	end
	local type=c:GetOriginalType()
	local te2=c:SetCardData(CARDDATA_TYPE,type&~TYPE_SPSUMMON,0,RESET_CHAIN,c)
	-- local ae2={c:IsHasEffect(EFFECT_REVIVE_LIMIT)}
	-- for _,te in ipairs(ae2) do
	-- 	table.insert(eff,te)
	-- 	te:Reset()
	-- end
	chk=(c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1))
	e1:Reset()
	for _,te in ipairs(eff) do
		c:RegisterEffect(te)
	end
	te2:Reset()
	return chk
end
function s.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.adfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,s.adfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_RELEASE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local eff={}
		local ae={tc:IsHasEffect(EFFECT_UNSUMMONABLE_CARD)}
		if ae then
			for _,te in ipairs(ae) do
				table.insert(eff,te)
				te:Reset()
			end
		end
		local type=tc:GetOriginalType()
		local te2=tc:SetCardData(CARDDATA_TYPE,type&~TYPE_SPSUMMON,0,RESET_CHAIN,tc)
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
		tc:CompleteProcedure()
		for _,te in ipairs(eff) do
			tc:RegisterEffect(te)
		end
		te2:Reset()
	end
end

function s.infacfilter(c,left,right)
	local seq=c:GetSequence()
	return c:IsFaceup() and left<seq and seq<right and c:IsSetCard(0x316)
end
function s.acinffilter(c,left,tp)
	local right=c:GetSequence()
	if right>4 then return false end
	if left>right then left,right=right,left end
	return c:IsFaceup() and c:IsSetCard(0x316) and c:IsLevelAbove(6) and Duel.IsExistingMatchingCard(s.infacfilter,tp,LOCATION_MZONE,0,1,nil,left,right)
end
function s.discondition(e)
	local tp=e:GetHandler():GetControler()
	local left=e:GetHandler():GetSequence()
	local ig=Duel.GetMatchingGroup(s.acinffilter,tp,LOCATION_MZONE,0,nil,left,tp)
	if #ig<1 then return false end
	return true
end
function s.distarget(e,c)
	local tp=e:GetHandler():GetControler()
	local left=e:GetHandler():GetSequence()
	local ig=Duel.GetMatchingGroup(s.acinffilter,tp,LOCATION_MZONE,0,nil,left,tp)
	if #ig<1 then return end
	local ic=ig:GetMaxGroup(Card.GetSequence):GetFirst()
	local right=ic:GetSequence()
	if left>right then left,right=right,left end
	return s.infacfilter(c,left,right)
end

function s.adtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local left=e:GetHandler():GetSequence()
	local ig=Duel.GetMatchingGroup(s.acinffilter,tp,LOCATION_MZONE,0,nil,left,tp)
	if chk==0 then return #ig>0 end
end
function s.adop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local left=e:GetHandler():GetSequence()
	local ig=Duel.GetMatchingGroup(s.acinffilter,tp,LOCATION_MZONE,0,nil,left,tp)
	if #ig<1 then return end
	local ic=ig:GetMaxGroup(Card.GetSequence):GetFirst()
	local right=ic:GetSequence()
	if left>right then left,right=right,left end
	local ag=Duel.GetMatchingGroup(s.infacfilter,tp,LOCATION_MZONE,0,nil,left,right)
	while ag:GetCount()>0 do
		local sqtc=ag:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.RaiseSingleEvent(sqtc,EVENT_SUMMON_SUCCESS,e,0,tp,tp,0)
		Duel.RaiseEvent(sqtc,EVENT_SUMMON_SUCCESS,e,0,tp,tp,0)
		ag:RemoveCard(sqtc)
	end
end