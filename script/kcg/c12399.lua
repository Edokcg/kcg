--Orichalcos Shunoros
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)

	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_NOT_EXTRA)
	e00:SetValue(1)
	c:RegisterEffect(e00)

	--spsummon Divine Sepent
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetDescription(aux.Stringid(12399,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)

	--Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12399,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(s.tg)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)	

	--ATK goes down
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BATTLED)
	e6:SetCondition(s.statcon)
	e6:SetOperation(s.statop)
	c:RegisterEffect(e6)

	local e08=Effect.CreateEffect(c)
	e08:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e08:SetCode(EVENT_SPSUMMON_SUCCESS)
	e08:SetOperation(s.saveatk)
	c:RegisterEffect(e08)

	--selfdestroy
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_SELF_DESTROY)
	e8:SetCondition(s.descon)
	--c:RegisterEffect(e8)

	--protected card damage effects
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetTarget(s.indes)
	e9:SetValue(1)
	c:RegisterEffect(e9)
end
s.listed_names={12398,123100,123106,123104}

function s.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(123104)
end

function s.indes(e,c)
	return c:IsFaceup() and c:IsCode(12398,123100)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and Duel.GetLP(tp)>=10000 
end

function s.spfilter(c,e,tp)
	return c:IsCode(123106) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end

function s.spfilter2(c,e,tp)
	return c:IsCode(123100) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.spfilter3(c,e,tp)
	return c:IsCode(12398) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)>1
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)<2 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,s.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		local tc1=g1:GetFirst()
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP) 
		tc1:CompleteProcedure()
		g2:GetFirst():CompleteProcedure()
	end
end

function s.statcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	return c==a and b
end
function s.statop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if Duel.GetAttacker()~=e:GetHandler() or bc==nil then return end
	local atk=bc:GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	if bc:IsAttackPos() then
		e1:SetCode(EFFECT_UPDATE_ATTACK)
	else
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		atk=bc:GetDefense()
	end
	e1:SetValue(-atk)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
end

function s.descon(e)
	return e:GetHandler():GetAttack()==0
end
function s.saveatk(e,tp,eg,ep,ev,re,r,rp)
	local e8=Effect.CreateEffect(e:GetHandler())
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_SELF_DESTROY)
	e8:SetReset(RESET_EVENT+RESETS_STANDARD)
	e8:SetCondition(s.descon)
	e:GetHandler():RegisterEffect(e8,true)
end