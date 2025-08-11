--Knight Of Destiny 
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),1,99,293)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(s.adjustcon)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)

	--cannot special summon
	local e01=Effect.CreateEffect(c)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_SPSUMMON_CONDITION)
	e01:SetValue(aux.FALSE)
	c:RegisterEffect(e01)

	local e001=Effect.CreateEffect(c)
	e001:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e001:SetType(EFFECT_TYPE_SINGLE)
	e001:SetCode(EFFECT_OVERINFINITE_ATTACK)
	c:RegisterEffect(e001)  
	local e002=Effect.CreateEffect(c)
	e002:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e002:SetType(EFFECT_TYPE_SINGLE)
	e002:SetCode(EFFECT_OVERINFINITE_DEFENSE)
	c:RegisterEffect(e002)

	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.econ)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)	

	-- local e4=Effect.CreateEffect(c)
	-- e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	-- e4:SetType(EFFECT_TYPE_SINGLE)
	-- e4:SetCode(EFFECT_MATERIAL_CHECK)
	-- e4:SetValue(s.valcheck)
	-- c:RegisterEffect(e4)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	-- e8:SetLabelObject(e4)
	e8:SetOperation(s.sucop)
	c:RegisterEffect(e8)

	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e100:SetRange(LOCATION_MZONE)
	e100:SetCode(EFFECT_CANNOT_DISABLE)
	e100:SetValue(1)
	c:RegisterEffect(e100)
	local e101=e100:Clone()
	e101:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e101)

	--特殊召唤不会被无效化
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e9)

	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(35699,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)	
end
s.listed_series={0x900,0xa0}
s.listed_names={293}

function s.valcheck(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local tatk=0
	local tdef=0
	while tc do
	local atk=tc:GetPreviousAttackOnField()
	local def=tc:GetPreviousDefenseOnField()
	if atk<0 then atk=0 end
	if def<0 then def=0 end
	tatk=tatk+atk
	tdef=tdef+def
	tc=g:GetNext() end
	Original_ATK=tatk
	Original_DEF=tdef
end
function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if g:GetCount()<1 then return end
	local tc=g:GetFirst()
	local tatk=0
	local tdef=0
	while tc do
		local atk=tc:GetPreviousAttackOnField()
		local def=tc:GetPreviousDefenseOnField()
		if atk<0 then atk=0 end
		if def<0 then def=0 end
		tatk=tatk+atk
		tdef=tdef+def
		c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD_DISABLE,1)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(tatk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(tdef)
	c:RegisterEffect(e2)
end

function s.adjustcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(s.adfilter,tp,LOCATION_ONFIELD,0,nil)>0
end
function s.adfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x900) and c:IsType(TYPE_FIELD)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.adfilter,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_RULE+REASON_EFFECT)
	end
end

function s.econ(e)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0xa0) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,3,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0x13)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g>2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,3,3,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
	end
end