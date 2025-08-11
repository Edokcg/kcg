--ユベル－Das Abscheulich Ritter
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(4779091,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_REPEAT)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(s.descon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop) 
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	-- e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	-- e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e5:SetRange(LOCATION_MZONE)
	-- e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetDescription(aux.Stringid(4779091,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetTarget(s.desreptg)
	e5:SetOperation(s.desrepop)
	c:RegisterEffect(e5)

	--cannot special summon
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(s.splimit)
	c:RegisterEffect(e6)
end
s.listed_names={31764700, 78371393}

function s.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(78371393)
end

function s.damop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	Duel.RegisterEffect(e1,tp)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.sfilter(c)
	return c:IsOnField()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
		local g1count=Duel.GetMatchingGroupCount(s.sfilter,tp,LOCATION_MZONE,0,e:GetHandler())
		local g2count=Duel.GetMatchingGroupCount(s.sfilter,1-tp,LOCATION_MZONE,0,e:GetHandler())
	  local count=g1count+g2count
	  if g1count<g2count then count=g1count*2 end
	  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,count,0,0) 
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
		local g1=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	  if g1~=nil then
	if Duel.Destroy(g1,REASON_EFFECT)>0 then
	  g1=Duel.GetOperatedGroup()
	  Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	  local g2=Duel.SelectMatchingCard(tp,s.sfilter,tp,0,LOCATION_MZONE,g1:GetCount(),g1:GetCount(),nil)
	  if g2~=nil then
	Duel.Destroy(g2,REASON_EFFECT) end end end
end

function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
	-- if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsCode(id) end
	-- if Duel.SelectEffectYesNo(tp,c,96) then
	-- 	return true
	-- else return false end
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP) then return end
	c:SetEntityCode(22, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
	aux.CopyCardTable(22,c)
	c:CopyEffect(id,RESET_EVENT+RESETS_STANDARD,1)
	Duel.SpecialSummonComplete()
	c:CompleteProcedure()
end
