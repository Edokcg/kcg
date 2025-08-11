--BT黑羽 奇斯(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  c:EnableReviveLimit()
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	if aux.IsKCGScript then	
		e1:SetCondition(s.kspcon)
		e1:SetOperation(s.kspop)
	else 
		e1:SetCondition(s.spcon)
		e1:SetOperation(s.spop)
	end
	c:RegisterEffect(e1)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(s.tg)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)
end
if not aux.IsKCGScript then	
	s.spchecks=aux.CreateChecks(Card.IsCode,{77240653,77240652,77240649})
end 
function s.spcfilter1(c)
    return c:IsCode(77240653) and c:IsAbleToRemoveAsCost()
end
function s.spcfilter2(c)
    return c:IsCode(77240652) and c:IsAbleToRemoveAsCost()
end
function s.spcfilter3(c)
    return c:IsCode(77240649) and c:IsAbleToRemoveAsCost()
end
function s.kspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spcfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spcfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spcfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function s.kspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,s.spcfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,s.spcfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local g3=Duel.SelectMatchingCard(tp,s.spcfilter3,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp)) or
		(Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_REMOVED,1,nil,e,1-tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,2,LOCATION_REMOVED)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft1=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_REMOVED,0,ft1,ft1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				tc=g:GetNext()
			end
		end
	end
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft2>0 then
		if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,s.filter,tp,0,LOCATION_REMOVED,ft2,ft2,nil,e,1-tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
				tc=g:GetNext()
			end
		end
	end
	Duel.SpecialSummonComplete()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.spcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:CheckSubGroupEach(s.spchecks,aux.mzctcheck,tp)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.spcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroupEach(tp,s.spchecks,false,aux.mzctcheck,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end