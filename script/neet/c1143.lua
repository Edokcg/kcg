--般若(neet)
local m=1143
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	--aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,TYPE_SPIRIT),4,2,cm.ovfilter,aux.Stringid(m,0))
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SPIRIT),4,2,cm.ovfilter,aux.Stringid(m,0))
	c:EnableReviveLimit()
	local sme,soe=Spirit.AddProcedure(c,EVENT_SPSUMMON_SUCCESS)
	--Mandatory return
	sme:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	sme:SetTarget(cm.mrettg)
	sme:SetOperation(cm.retop)
	--Optional return
	soe:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	soe:SetTarget(cm.orettg)
	soe:SetOperation(cm.retop)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.rmcost)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(cm.atcon)
	c:RegisterEffect(e2)
end
cm.listed_card_types={TYPE_SPIRIT}
function cm.rmfilter(c)
	return c:IsReleasable()
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g1=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectTarget(tp,cm.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT) and not c:IsLevel(4)
end
function cm.mrettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Spirit.MandatoryReturnTarget(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.tkcheck(e,tp)
	return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
end
function cm.orettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Spirit.OptionalReturnTarget(e,tp,eg,ep,ev,re,r,rp,0) and cm.tkcheck(e,tp) end
	Spirit.OptionalReturnTarget(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_EXTRA) and cm.tkcheck(e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==1
end