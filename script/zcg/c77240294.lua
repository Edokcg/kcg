--装甲 至宝黄金叉 （ZCG）
function c77240294.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c77240294.target)
	e1:SetOperation(c77240294.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(c77240294.adval)
	c:RegisterEffect(e2)
	--equip limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c77240294.eqlimit)
	c:RegisterEffect(e6)
end
function c77240294.filter(c)
	return c:IsFaceup() and not c:IsCode(21208154) and not c:IsHasEffect(21208154)
end
function c77240294.adval(e,c)
	local g=Duel.GetMatchingGroup(c77240294.filter,0,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then
		return 1000
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val+1000
	end
end
function c77240294.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler()
end
function c77240294.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77240294.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Equip(tp,e:GetHandler(),tc)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetRange(LOCATION_SZONE)
		e4:SetTargetRange(0,LOCATION_MZONE)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e4)
	end
end









