--上古末日甲虫之茧(ZCG)
local s,id=GetID()
function s.initial_effect(c)
													   --immue 
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(EFFECT_IMMUNE_EFFECT)
	e17:SetRange(LOCATION_MZONE)
	e17:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e17:SetTarget(s.tger)
	e17:SetValue(s.efilter)
	c:RegisterEffect(e17)
	local e18=e17:Clone()
	e18:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e18:SetValue(s.indes)
	c:RegisterEffect(e18)
	--aclimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetOperation(s.regop)
	c:RegisterEffect(e6)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)   
	e1:SetOperation(s.winop)
	e1:SetCountLimit(1)
	e1:SetLabel(0) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	Duel.RegisterEffect(e1,tp)
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
   if Duel.GetTurnPlayer()==tp then
	local ct=e:GetLabel()
	ct=ct+1
	Debug.Message(ct)
	e:SetLabel(ct)
if ct>=3 then
--
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	--e2:SetCondition(s.con) 
	e2:SetCost(s.cost)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	e:GetHandler():RegisterEffect(e2)
end 
end
end
function s.filter(c,e,tp)
	return c:IsCode(77240396) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
 if chk == 0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil, e, tp)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK+LOCATION_GRAVE)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
	Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP) 
end
function s.indes(e,c)
	return not (c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER))
end
function s.tger(e,c)
	return c:IsSetCard(0xa120)
end
function s.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xa120) and te:IsActiveType(TYPE_MONSTER)
end