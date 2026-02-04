--地缚神 红莲之恶魔
local s,id=GetID()
function s.initial_effect(c)
	
	--Can Attack Directly
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(s.havefieldcon)
	c:RegisterEffect(e1)

	--Unaffected by Spell and Trap Cards
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(s.havefieldcon)
	e2:SetValue(s.unaffectedval)
	c:RegisterEffect(e2)

	--Cannot be Battle Target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.havefieldcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	
	--墓地地缚神数量提升攻击
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)
	
	--Banish this card and negate an attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.bancon)
	e5:SetTarget(s.bantg)
	e5:SetOperation(s.banop)
	c:RegisterEffect(e5)
	--Return this card to the field
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_REMOVED)
	e6:SetCountLimit(1)
	e6:SetTarget(s.rettg)
	e6:SetOperation(s.retop)
	c:RegisterEffect(e6)

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(s.nofieldcon)
	e7:SetOperation(s.nofieldop)
	c:RegisterEffect(e7)
	
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,3))
	e8:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e8:SetCountLimit(1,id)
	e8:SetHintTiming(0,TIMING_MAIN_END)
	e8:SetCondition(function() return Duel.IsMainPhase() end)
	e8:SetCost(Cost.SelfBanish)
	e8:SetTarget(s.tgtg)
	e8:SetOperation(s.tgop)
	c:RegisterEffect(e8)

	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(id)
	e10:SetTargetRange(1,0)
	e10:SetCondition(s.havefieldcon)
	e10:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e10)
	aux.ChangePlayerEffect({EFFECT_CANNOT_SPECIAL_SUMMON,EFFECT_CANNOT_SUMMON,EFFECT_CANNOT_FLIP_SUMMON},c,id,function(te,tc) return Duel.GetPlayerEffect(te:GetOwnerPlayer(),id) and tc:IsSetCard(SET_EARTHBOUND_IMMORTAL) end)
end
s.listed_names={CARD_RED_DRAGON_ARCHFIEND,97489701} --"Red Nova Dragon"
s.listed_series={SET_EARTHBOUND,SET_EARTHBOUND_IMMORTAL}
------------------------------------------------------------------------------------------------------------
function s.havefieldcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function s.unaffectedval(e,te)
	return te:IsSpellTrapEffect() and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
----------------------------------------------------------------------------------------------------------
function s.dfilter(c)
	return c:IsSetCard(SET_EARTHBOUND)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.dfilter,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_TUNER)*1000
end

function s.bancon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp) and (Duel.IsAbleToEnterBP() or Duel.IsBattlePhase()) and Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
		local ac=Duel.GetAttacker()
		if ac and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.NegateAttack()
		else
			--You can negate 1 attack this turn from a monster your opponent controls
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ATTACK_ANNOUNCE)
			e1:SetOperation(s.negop)
			e1:SetReset(RESET_PHASE|PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,1-tp,id)
		Duel.NegateAttack()
		e:Reset()
	end
end

function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():HasFlagEffect(id) end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ReturnToField(c)
	end
end

function s.nofieldcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function s.nofieldop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function s.tgfilter(c)
	return (c:IsSetCard(SET_EARTHBOUND_IMMORTAL) or c:IsCode(CARD_RED_DRAGON_ARCHFIEND)) and c:IsMonster() and c:IsAbleToGrave()
		and (c:IsFaceup() or not c:IsOnField())
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND|LOCATION_MZONE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_EXTRA)
end
function s.earthboundspfilter(c,e,tp)
	if not (c:IsSetCard(SET_EARTHBOUND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_DECK) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	elseif c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)
	end
end
function s.rednovaspfilter(c,e,tp)
	return c:IsCode(97489701) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local gc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil):GetFirst()
	if gc and Duel.SendtoGrave(gc,REASON_EFFECT)>0 and gc:IsLocation(LOCATION_GRAVE) then
		local b1=Duel.IsExistingMatchingCard(s.earthboundspfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,nil,e,tp)
		local b2=Duel.IsExistingMatchingCard(s.rednovaspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		if not ((b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(id,1))) then return end
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,2)},
			{b2,aux.Stringid(id,3)})
		if op==1 then
			--Special Summon 1 "Earthbound" monster from your Deck or Extra Deck
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.earthboundspfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,1,nil,e,tp)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		elseif op==2 then
			--Special Summon "Red Nova Dragon" from your Extra Deck
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,s.rednovaspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			if not sc then return end
			Duel.BreakEffect()
			if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
				sc:CompleteProcedure()
			end
		end
	end
end