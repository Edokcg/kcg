--暗之魔力
function c77239022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77239022.target)
	e1:SetOperation(c77239022.operation)
	c:RegisterEffect(e1)
end
function c77239022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c77239022.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
		if Duel.GetControl(tc,tp) then
	        --不受影响
	        local e1=Effect.CreateEffect(e:GetHandler())
	        e1:SetType(EFFECT_TYPE_SINGLE)
	        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	        e1:SetValue(c77239022.efilter)	
	        e1:SetRange(LOCATION_MZONE)
	        e1:SetCode(EFFECT_IMMUNE_EFFECT)	
	        tc:RegisterEffect(e1)
		elseif not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c77239022.efilter(e,re)
	return re:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER) and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end