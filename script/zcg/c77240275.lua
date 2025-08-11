--装甲 改造战士 （ZCG）
function c77240275.initial_effect(c)
	  local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetDescription(aux.Stringid(98710695,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c77240275.eqccon)
	e1:SetTarget(c77240275.eqtg)
	e1:SetOperation(c77240275.eqop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98710695,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c77240275.descon)
	e2:SetTarget(c77240275.destg)
	e2:SetOperation(c77240275.desop)
	c:RegisterEffect(e2)
end
function c77240275.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c77240275.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c77240275.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77240275.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,c) end
	local sg=Duel.GetMatchingGroup(c77240275.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240275.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77240275.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,e:GetHandler())
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
end


function c77240275.eqccon(e,tp,eg,ep,ev,re,r,rp)
	return 1-tp==Duel.GetTurnPlayer()
end
function c77240275.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77240275.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c77240275.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c77240275.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end