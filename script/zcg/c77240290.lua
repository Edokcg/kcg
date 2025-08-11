--装甲 植物充能 （ZCG）
function c77240290.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77240290.target)
	e1:SetOperation(c77240290.activate)
	c:RegisterEffect(e1)
end
function c77240290.chkfilter(c)
return c:IsRace(RACE_PLANT+RACE_MACHINE)
end
function c77240290.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c77240290.chkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77240290.chkfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c77240290.chkfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77240290.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
  if Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)==0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
  local tc2=g:GetFirst()
  if not Duel.Equip(tp,tc,tc2,false) then return end
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c77240290.eqlimit)
		e1:SetLabelObject(tc2)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(77240290,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(c77240290.atkval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e2)
	end
end
function c77240290.eqlimit(e,c)
	return  c==e:GetLabelObject()
end
function c77240290.atkfilter(c)
return c:GetFlagEffect(77240290)>0
end
function c77240290.atkval(e,c)
	local eg=c:GetEquipGroup():Filter(c77240290.atkfilter,nil)
	local atk=eg:GetFirst():GetAttack()
	return atk 
end





