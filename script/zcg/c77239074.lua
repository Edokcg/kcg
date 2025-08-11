--皆
function c77239074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77239074.target)
	e1:SetOperation(c77239074.activate)
	c:RegisterEffect(e1)
end
function c77239074.filter2(c,e,tp)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and (c:IsRace(RACE_FIEND) or c:IsRace(RACE_ZOMBIE))
end
function c77239074.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(c77239074.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c77239074.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c77239074.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) --[[and not Duel.GetControl(tc,tp,1)]] then
			Duel.GetControl(tc,tp,0,0)
			local e1=Effect.CreateEffect(e:GetHandler())
	        e1:SetType(EFFECT_TYPE_FIELD)
	        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	        e1:SetTargetRange(0,1)
	        e1:SetValue(c77239074.aclimit)
	        e1:SetReset(RESET_PHASE+PHASE_END,4)
	        Duel.RegisterEffect(e1,tp)
	end
end
function c77239074.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end