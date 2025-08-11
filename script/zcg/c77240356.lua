--不死之恶魔的召唤(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  --attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cosfilter(c)
return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cosfilter,tp,LOCATION_GRAVE,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,s.cosfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	 Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.filter(c)
return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	 local tc=Duel.GetFirstTarget()
	  if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
















