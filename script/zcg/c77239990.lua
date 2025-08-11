--新宇圣龙魔导骑士
function c77239990.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode3(c,89943723,46986414,44508094,false,false)

	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)

	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c77239990.spop)
	c:RegisterEffect(e2)

	--Attribute Dark
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_ADD_ATTRIBUTE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e3)

	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c77239990.val)
	c:RegisterEffect(e4)
	
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	
	--cannot release
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c77239990.rmfilter)
	c:RegisterEffect(e7)

	--negate activate
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77239990,0))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCost(c77239990.cost)
	e8:SetTarget(c77239990.target)
	e8:SetOperation(c77239990.activate)
	c:RegisterEffect(e8)	
	
	--Negate
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(77239990,1))
	e9:SetCategory(CATEGORY_NEGATE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_CHAINING)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCost(c77239990.cost1) 
	e9:SetCondition(c77239990.codisable)
	e9:SetTarget(c77239990.tgdisable)
	e9:SetOperation(c77239990.opdisable)
	c:RegisterEffect(e9)	

	--Revive
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(77239990,2))
	e10:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetCode(EVENT_PHASE+PHASE_END)
	e10:SetRange(LOCATION_GRAVE)
	e10:SetCountLimit(1)
	e10:SetTarget(c77239990.sumtg)
	e10:SetOperation(c77239990.sumop)
	c:RegisterEffect(e10)

	--special summon
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(77239990,2))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_DESTROYED)
	e11:SetTarget(c77239990.target1)
	e11:SetOperation(c77239990.operation1)
	c:RegisterEffect(e11)   
end
--------------------------------------------------------------
function c77239990.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(c77239990.efilter)
	e:GetHandler():RegisterEffect(e1)
end
function c77239990.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--------------------------------------------------------------
function c77239990.val(e,c)
	return Duel.GetMatchingGroupCount(c77239990.filter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil)*500
end
function c77239990.filter(c)
	return (c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_DRAGON)) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
--------------------------------------------------------------
function c77239990.rmfilter(e,te)
	return e:GetHandler()~=te:GetHandler()
end
--------------------------------------------------------------
function c77239990.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c77239990.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239990.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
--------------------------------------------------------------
function c77239990.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
	or e:GetHandler():IsReleasable() end
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(77239990,3)) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	else
		Duel.Release(e:GetHandler(),REASON_COST)	
	end 
end
function c77239990.codisable(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c77239990.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77239990.opdisable(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(77239990,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)	 
end
--------------------------------------------------------------
function c77239990.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(77239990)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c77239990.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
	end
end
--------------------------------------------------------------
function c77239990.filter2(c,e,tp)
	return bit.band(c:GetReason(),0x40008)==0x40008 and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239990.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c77239990.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c77239990.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function c77239990.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
	end
end




