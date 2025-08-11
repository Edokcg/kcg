--极星天 格尔塞蜜（neet）
local s,id=GetID()
function s.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
 --change
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetCountLimit(1,id+1)
	e10:SetCost(s.ccost)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(s.spcon)
	e10:SetOperation(s.op)
	c:RegisterEffect(e10)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x42) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
s.listed_series={0x42}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsType,TYPE_TUNER),tp,LOCATION_MZONE,0,nil)==0
end
function s.costfilter(c,ec)
	return c:IsSetCard(0x42) and c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()
end
function s.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,c)
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabel(cg:GetFirst():GetCode())
	e:SetLabelObject(cg:GetFirst())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not sc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(sc:GetLevel())
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(e:GetLabel())
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetValue(TYPE_TUNER)
	c:RegisterEffect(e3)
end