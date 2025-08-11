--殉道者之魔法升华（ZCG）
function c77240219.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c77240219.target)
	e1:SetOperation(c77240219.activate)
	c:RegisterEffect(e1)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c77240219.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(0,LOCATION_ONFIELD)
	e12:SetTarget(c77240219.distg9)
	c:RegisterEffect(e12)
end
function c77240219.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function c77240219.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end
function c77240219.filter(c)
	return c:IsType(TYPE_SPELL) and not (c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_EQUIP) or c:IsType(TYPE_QUICKPLAY) or c:IsType(TYPE_RITUAL) or c:IsType(TYPE_FIELD) or c:IsType(TYPE_LINK))
end
function c77240219.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c77240219.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c77240219.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,c77240219.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler())
end
function c77240219.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	code=tc:GetOriginalCodeRule()
	if tc:IsRelateToEffect(e) then
	--set instead of send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_ALL)
	e1:SetCondition(c77240219.setcon)
	e1:SetOperation(c77240219.setop)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetRange(LOCATION_ALL)
	e2:SetValue(TYPE_CONTINUOUS)
	tc:RegisterEffect(e2)
   end
end
function c77240219.setcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return  rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
		and rc:IsCode(code) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and rc:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c77240219.setop(e,tp,eg,ep,ev,re,r,rp)
   local rc=re:GetHandler()
		rc:CancelToGrave()
		Duel.ChangePosition(rc,POS_FACEDOWN)
		Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end