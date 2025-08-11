--黑魔术女孩 白将(ZCG)
function c77239952.initial_effect(c)
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c77239952.valcon)
	c:RegisterEffect(e1)

	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239952,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c77239952.shtg)
	e2:SetOperation(c77239952.shop)
	c:RegisterEffect(e2)

	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c77239952.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)	
	
	--[[equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77239952,0))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetTarget(c77239952.eqtg)
	e5:SetOperation(c77239952.eqop)
	c:RegisterEffect(e5)]]
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77239952,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c77239952.eqcon)
	e5:SetTarget(c77239952.eqtg)
	e5:SetOperation(c77239952.eqop)
	c:RegisterEffect(e5)
end
-----------------------------------------------------------------
function c77239952.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
-----------------------------------------------------------------
function c77239952.filter(c)
	return c:IsLevelAbove(5) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c77239952.filter1(c)
	return --[[c:IsSetCard(0x10a2) and]] c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c77239952.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239952.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c77239952.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239952.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77239952.filter,tp,LOCATION_DECK,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(tp,c77239952.filter1,tp,LOCATION_DECK,0,1,1,nil)
	g:Merge(g1)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-----------------------------------------------------------------
function c77239952.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,RACE_SPELLCASTER)*300
end
-----------------------------------------------------------------
--[[function c77239952.filter2(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c77239952.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c77239952.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c77239952.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77239952.eqlimit(e,c)
	return e:GetOwner()==c
end
function c77239952.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc,true)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c77239952.eqlimit)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(900)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetValue(1)
		c:RegisterEffect(e3)
	end
end]]
function c77239952.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():CheckUniqueOnField(tp)
end
function c77239952.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c77239952.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239952.spfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c77239952.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c77239952.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c77239952.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c77239952.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	--defenseup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetValue(1)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
end
function c77239952.eqlimit(e,c)
	return c==e:GetLabelObject()
end