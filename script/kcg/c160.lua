--オッドアイズ・グラビティ・ドラゴン
--Odd-Eyes Gravity Dragon
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)

	--atk limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(s.atlimit)
	c:RegisterEffect(e3)

	--activate cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCost(s.costchk)
	e4:SetOperation(s.costop)
	c:RegisterEffect(e4)

	--accumulate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(id)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	c:RegisterEffect(e6)

	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(s.spcost)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop2)
	c:RegisterEffect(e5)
end
s.listed_series={0x20f8}
s.listed_names={57, 13331639}

function s.spfilter(c,tp)
	return c:IsControler(1-tp) and c:IsType(TYPE_RITUAL) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(13331639)
end
function s.rescon(sg,e,tp,mg)
	local c=e:GetHandler()
	return aux.ChkfMMZ(1)(sg,e,tp,mg)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eff={c:GetCardEffect(EFFECT_NECRO_VALLEY)}
	for _,te in ipairs(eff) do
		local op=te:GetOperation()
		if not op or op(e,c) then return false end
	end
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsSetCard,nil,0x20f8)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_RITUAL)
	return #pg<=0 and eg:IsExists(s.spfilter,1,nil,tp) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and #g>1 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsSetCard,nil,0x20f8)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_RITUAL)
	if #pg<=0 and #g>1 and aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,0) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) 
		and Duel.SelectEffectYesNo(tp,c) then
		local sg=aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,1,tp,HINTMSG_RELEASE)
		Duel.Release(sg,REASON_COST)
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end

function s.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.stfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(s.stfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
	Duel.SetChainLimit(s.chlimit)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.stfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end

function s.atlimit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c~=e:GetHandler()
end

function s.costchk(e,te_or_c,tp)
	local ct=#{Duel.GetPlayerEffect(tp,id)}
	return Duel.CheckLPCost(tp,ct*500)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function s.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x20f8) and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>1
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and aux.CheckSummonGate(tp,2)
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or not aux.CheckSummonGate(tp,2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,2,2,nil,e,tp)
	if #g<1 then return end
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		for tc in aux.Next(Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)) do
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK_FINAL)
			e2:SetValue(0)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
