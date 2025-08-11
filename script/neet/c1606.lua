--光道治疗师 伊阿索(neet)
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsAttribute,ATTRIBUTE_LIGHT),1,99)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e) return e:GetHandler():IsSynchroSummoned() and e:GetHandler():GetMaterialCount()>0 end)
	e1:SetCountLimit(1)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.effcon)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterialCount()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetMaterialCount()
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
end
function s.cfilter(c,tp)
	if not c:IsPreviousLocation(LOCATION_DECK) or not c:IsControler(tp) then return false end
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsSetCard(0x38) or (c:ListsArchetype(0x38) and c:IsSpellTrap())
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x38) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.listsfilter(c)
	return c:ListsArchetype(0x38) and c:IsSpellTrap()
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0
	local b2=Duel.IsPlayerCanDraw(tp,1) and eg:FilterCount(Card.IsSetCard,nil,0x38)>0
	local b3=eg:FilterCount(s.listsfilter,nil)>0
	if chk==0 then return b1 or b2 or b3 end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local breakeffect=false
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)>0
	local b2=Duel.IsPlayerCanDraw(tp,1) and eg:FilterCount(Card.IsSetCard,nil,0x38)>0
	local b3=eg:FilterCount(s.listsfilter,nil)>0
	if b1 and ((not b2 and not b3) or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		breakeffect=true
	end
	if b2 and ((not breakeffect and not b3) or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
		Duel.Draw(tp,1,REASON_EFFECT)
		breakeffect=true
		if breakeffect then Duel.BreakEffect() end
	end
	if b3 and (not breakeffect or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
		Duel.Recover(tp,1500,REASON_EFFECT)
		breakeffect=true
		if breakeffect then Duel.BreakEffect() end
	end
end