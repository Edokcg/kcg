--守墓的继承者(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x2e),1,1)
	--immune to necro valley
	--[[local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_NECRO_VALLEY_IM)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)]]--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_NECRO_VALLEY_IM)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0xff,0)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)	
end
s.listed_series={0x2e}
s.listed_names={CARD_NECROVALLEY}
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and g and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x2e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK|POS_FACEUP_DEFENSE)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local relation=rc:IsRelateToEffect(re)
	if chk==0 then return (rc:IsAbleToRemove(tp)
		or (not relation and Duel.IsPlayerCanRemove(tp))) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)  end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if relation then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,rc:GetControler(),rc:GetLocation())
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,rc:GetPreviousLocation())
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		local ct=Duel.Remove(eg,POS_FACEUP,REASON_EFFECT) 
	end
	if ct==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not sc then return end
	Duel.BreakEffect()
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_ATTACK|POS_FACEDOWN_DEFENSE)~=0 and sc:IsFacedown() then
		Duel.ConfirmCards(1-tp,sc)
	end
end