--地中族邪界兽·达尼尔黑死兽(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH),3,nil,s.matcheck)	
	--Unaffected by other cards' effects
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(s.imcon)
	e0:SetValue(function(e,te) return te:GetOwner()~=e:GetOwner() end)
	c:RegisterEffect(e0)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
	--special sum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_series={0x10ed}
function s.matcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsType,1,nil,TYPE_FLIP,lc,sumtype,tp)
end
function s.imfilter(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function s.imcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(s.imfilter,1,nil)
end
function s.posfilter(c,e,tp)
	return c:IsFacedown() or (c:IsFaceup() and c:IsCanTurnSet()) and c:IsCanBeEffectTarget(e)
end
function s.desrescon(maxc)
	return function(sg,e,tp,mg)
		local ct1=sg:FilterCount(Card.IsControler,nil,tp)
		local ct2=#sg-ct1
		return ct1==ct2,ct1>maxc or ct2>maxc
	end
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.posfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(s.posfilter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	local ct=g:FilterCount(Card.IsControler,nil,tp)
	local rescon=s.desrescon(math.min(ct,#g-ct))
	local tg=aux.SelectUnselectGroup(g,e,tp,2,#g,rescon,1,tp,HINTMSG_POSCHANGE,rescon)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,#tg,0,0)
end
function s.flipflop(c)
	Duel.ChangePosition(c,c:IsFaceup() and POS_FACEDOWN_DEFENSE or POS_FACEUP_DEFENSE)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	for tc in g:Iter() do s.flipflop(tc) end
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(s.cfilter,1,nil,1-tp)
		and Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD|LOCATION_HAND,0)>0
end
function s.spfilter(c,e,tp)
	return c:IsType(0x10ed) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP|POS_FACEDOWN_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP|POS_FACEDOWN_DEFENSE)
		if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
	end
end
