--BT黑羽 饿鹰进化(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.eqlimit)
	c:RegisterEffect(e2)
end
function s.eqlimit(e,c)
	return c:IsCode(77240650)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(77240650)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Equip(tp,e:GetHandler(),tc)~=0 then
			if Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)<=0 then return end
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
			if #g>=0 then   
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_UPDATE_ATTACK)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				e4:SetValue(g:GetFirst():GetAttack())
				tc:RegisterEffect(e4)
			end
		end
	end
end









