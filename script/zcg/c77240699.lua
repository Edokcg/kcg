--地缚神 查西略(ZCG)
local s,id=GetID()
function s.initial_effect(c)
   --special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,3))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
 --turn set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
 --disable effect
	local e52=Effect.CreateEffect(c)
	e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e52:SetCode(EVENT_CHAIN_SOLVING)
	e52:SetRange(LOCATION_MZONE)
	e52:SetOperation(s.disop2)
	c:RegisterEffect(e52)
	--disable
	local e53=Effect.CreateEffect(c)
	e53:SetType(EFFECT_TYPE_FIELD)
	e53:SetCode(EFFECT_DISABLE)
	e53:SetRange(LOCATION_MZONE)
	e53:SetTargetRange(0xa,0xa)
	e53:SetTarget(s.distg2)
	c:RegisterEffect(e53)
  --handes
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(s.condition2)
	e5:SetTarget(s.target2)
	e5:SetOperation(s.operation2)
	c:RegisterEffect(e5)
end
function s.dacfilter(c)
	return c:IsFaceup()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and  Duel.IsExistingMatchingCard(s.dacfilter,tp,LOCATION_FZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end

function s.disop2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end
function s.distg2(e,c)
	return c:GetCardTargetCount()>0  and c:GetCardTarget():IsContains(e:GetHandler())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanChangePosition() and not c:IsPosition(POS_FACEUP_DEFENSE) and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
















