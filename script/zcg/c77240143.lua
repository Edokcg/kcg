--装甲 战地龙虾
function c77240143.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77240143.spcon)
	e1:SetOperation(c77240143.spop1)
	c:RegisterEffect(e1)

	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	--e2:SetCondition(c77240143.drcon)
	e2:SetTarget(c77240143.target)
	e2:SetOperation(c77240143.activate)
	c:RegisterEffect(e2)

	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c77240143.sptg)
	e3:SetOperation(c77240143.spop2)
	c:RegisterEffect(e3)

	--disable effect
	local e52=Effect.CreateEffect(c)
	e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e52:SetCode(EVENT_CHAIN_SOLVING)
	e52:SetRange(LOCATION_MZONE)
	e52:SetOperation(c77240143.disop2)
	c:RegisterEffect(e52)
	--disable
	local e53=Effect.CreateEffect(c)
	e53:SetType(EFFECT_TYPE_FIELD)
	e53:SetCode(EFFECT_DISABLE)
	e53:SetRange(LOCATION_MZONE)
	e53:SetTargetRange(0,1)
	e53:SetTarget(c77240143.distg2)
	c:RegisterEffect(e53)
	--self destroy
	local e54=Effect.CreateEffect(c)
	e54:SetType(EFFECT_TYPE_FIELD)
	e54:SetCode(EFFECT_SELF_DESTROY)
	e54:SetRange(LOCATION_MZONE)
	e54:SetTargetRange(0,1)
	e54:SetTarget(c77240143.distg2)
	c:RegisterEffect(e54)
end
------------------------------------------------------------------
function c77240143.spcon(e,c)
	if c==nil then return true end
	--return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		--and Duel.IsPlayerCanDiscardDeckAsCost(tp,2)
	if c==nil then return true end
	return Duel.IsPlayerCanDiscardDeckAsCost(c:GetControler(),2) and 
	Duel.GetFieldGroupCount(c:GetControler(),LOCATION_DECK,0)>2
end
function c77240143.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.DiscardDeck(tp,2,REASON_COST)
end
------------------------------------------------------------------
function c77240143.filter1(c,e,tp)
	return c:IsCode(77240143) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240143.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c77240143.filter1,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77240143.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240143.filter1,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc=g:GetNext()
	end
end
------------------------------------------------------------------
function c77240143.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,0x41)==0x41 and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c77240143.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77240143.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77240143.filter2,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,c) end
	local sg=Duel.GetMatchingGroup(c77240143.filter2,tp,0,LOCATION_ONFIELD+LOCATION_HAND,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240143.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77240143.filter2,tp,0,LOCATION_ONFIELD+LOCATION_HAND,e:GetHandler())
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
end

function c77240143.disop2(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsControler(1-tp) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end
function c77240143.distg2(e,c)
	return c:GetCardTargetCount()>0 and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
		and c:GetCardTarget():IsContains(e:GetHandler())
end