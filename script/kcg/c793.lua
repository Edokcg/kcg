--キメラ・ハイドライブ・ドラグリッド
--Chimera Hydradrive Dragrid
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x577)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),5,5,s.lcheck)
	c:EnableReviveLimit()
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511600365,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ctcon)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end

function s.lcheck(g,lc,tp)
	return g:GetClassCount(Card.GetAttribute)==#g
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x577,1)
	end
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
	and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x577,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x577,1,REASON_COST)
end
function s.spfilter(c,e,tp,zone,dieResult,tc)
	return c:IsCode(789,790,791,792,796,797)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c,zone)>0
		and (not dieResult or c:IsAttribute(dieResult))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=0x01<<c:GetSequence()
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone,nil,c) and c:IsAbleToExtra() and c:GetSequence()>4 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetChainLimit(s.chlimit)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=0x01<<c:GetSequence()
	if zone==0 or not (Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone,nil,c) and c:IsAbleToExtra() and c:GetSequence()>4) then return end
	local dice=Duel.TossDice(tp,1)
	local dieResult=math.pow(2,(dice-1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone,dieResult,c)
	if g:GetCount()>0 then
		if c:IsRelateToEffect(e) then 
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)<1 then return end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone) end
	end
end