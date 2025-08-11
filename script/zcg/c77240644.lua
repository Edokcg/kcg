--BT黑羽 彩色凤凰(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(id,0))
	e99:SetCategory(CATEGORY_TODECK)
	e99:SetType(EFFECT_TYPE_IGNITION)
	e99:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCountLimit(1)
	e99:SetTarget(s.tg)
	e99:SetOperation(s.op)
	c:RegisterEffect(e99)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
