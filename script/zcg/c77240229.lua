--殉道者之能力封禁（ZCG）
function c77240229.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c77240229.target)
	e1:SetOperation(c77240229.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	--atkup
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_SET_BASE_DEFENSE)
	e7:SetValue(0)
	c:RegisterEffect(e7)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
--cannot change pos
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(1)
	c:RegisterEffect(e5)
--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(53610653,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c77240229.spcon)
	e6:SetTarget(c77240229.sptg)
	e6:SetOperation(c77240229.spop)
	c:RegisterEffect(e6)
	--equip limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_EQUIP_LIMIT)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetValue(1)
	c:RegisterEffect(e9)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c77240229.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(0,LOCATION_ONFIELD)
	e12:SetTarget(c77240229.distg9)
	c:RegisterEffect(e12)
end
function c77240229.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function c77240229.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end
function c77240229.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetPreviousEquipTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ec:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(ec)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,ec,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c77240229.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then	
	   if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		  Duel.BreakEffect()
		  Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,e:GetHandler())
		end
	end
end
function c77240229.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_LOST_TARGET)
		and not e:GetHandler():GetPreviousEquipTarget():IsLocation(LOCATION_ONFIELD+LOCATION_OVERLAY)
end
function c77240229.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77240229.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end