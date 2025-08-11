--圣刻龙-蒙龙
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.atkup)
	c:RegisterEffect(e2)
	--disable special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1350,1))
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.discon)
	e5:SetCost(s.discost)
	e5:SetTarget(s.distg)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)
end
s.listed_series={0x69}
function s.atkfilter(c)
	return (c:IsSetCard(0x69)
	or (c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON)))
	and c:IsType(TYPE_MONSTER)
end
function s.atkup(e,c)
	return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)*200
end
--disable special summon
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function s.discfilter(c)
	return (c:IsSetCard(0x69)
	or (c:IsType(TYPE_NORMAL)
	and c:IsRace(RACE_DRAGON)))
	and c:IsType(TYPE_MONSTER)
	and c:IsReleasable()
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.discfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.discfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end


