--装甲 研究台 （ZCG）
function c77240293.initial_effect(c)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240293,0))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c77240293.destg)
	e3:SetOperation(c77240293.desop)
	c:RegisterEffect(e3)
--control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77240293,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c77240293.destg2)
	e4:SetOperation(c77240293.desop2)
	c:RegisterEffect(e4)

end
function c77240293.filter(c)
	local tp=c:GetControler()
	return c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0 and c:IsSetCard(0xa110)
end
function c77240293.filter2(c)
	local tp=c:GetControler()
	return c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c77240293.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77240293.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c77240293.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,0,0,0)
end
function c77240293.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c77240293.filter,tp,LOCATION_MZONE,0,1,nil)
		or not Duel.IsExistingMatchingCard(c77240293.filter2,tp,0,LOCATION_MZONE,1,nil)
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectMatchingCard(tp,c77240293.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g1)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
	local g2=Duel.SelectMatchingCard(tp,c77240293.filter2,1-tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g2)
	local c1=g1:GetFirst()
	local c2=g2:GetFirst()
	Duel.SwapControl(c1,c2,0,0)
end
function c77240293.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77240293.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c77240293.filter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c77240293.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c77240293.filter,tp,LOCATION_MZONE,0,1,nil)
		or not Duel.IsExistingMatchingCard(c77240293.filter,tp,LOCATION_GRAVE,0,1,nil)
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c77240293.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g1)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c77240293.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.HintSelection(g2)
	local c1=g1:GetFirst()
	local c2=g2:GetFirst()
	Duel.SendtoGrave(c1,REASON_COST)
	Duel.MoveToField(c2,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
end















