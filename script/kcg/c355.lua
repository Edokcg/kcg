--反-光線 (K)
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(68396121,0))
	e5:SetProperty(0+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.negcon)
	e5:SetCost(s.negcost)
	e5:SetTarget(s.negtg)
	e5:SetOperation(s.negop)
	c:RegisterEffect(e5)	
end
s.listed_series={0x503}

function s.sFilter(c)
	return not c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsSetCard(0x503)
end
function s.xyzFilter(c,e,tp)
	return c:IsCode(356) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
--Special Summon target
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(s.sFilter,tp,LOCATION_MZONE,0,2,nil) 
							and Duel.IsExistingMatchingCard(s.xyzFilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,s.sFilter,tp,LOCATION_MZONE,0,2,60,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--Special Summon operation
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	count=g:GetCount()
	if count<2 then return end  
	local tc=g:GetFirst()
	if not tc then return end   
	local sg=Duel.SelectMatchingCard(tp,s.xyzFilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if not sc then return end
	Duel.Overlay(sc,g)
	  sc:SetMaterial(g)
	Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
end

function s.atkfilter3(c)
	return c:IsCode(355) and c:IsAbleToGraveAsCost()
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	local b=Duel.GetMatchingGroupCount(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	return a==b
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetOwner()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.filter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	  local tc=g:GetFirst()
	while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	  tc=g:GetNext()
	  end
end
