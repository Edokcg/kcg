--凭依解放-大稻荷神
function c1625.initial_effect(c)
	 --xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE),4,2)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c1625.lvtg)
	e1:SetValue(c1625.lvval)
	c:RegisterEffect(e1)
	--immune effect and directly attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1625,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1625.imcost)
	e2:SetTarget(c1625.imtg)
	e2:SetOperation(c1625.imop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1625,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1625)
	e3:SetCondition(c1625.thcon)
	e3:SetTarget(c1625.thtg)
	e3:SetOperation(c1625.thop)
	c:RegisterEffect(e3)
end
function c1625.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetOwner()~=e:GetHandlerPlayer()
end
function c1625.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 4
	else return lv end
end
-------------------------------------
function c1625.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1625.imfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c1625.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1625.imfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1625.imfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c1625.imfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c1625.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c1625.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c1625.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
-------------------------------------
function c1625.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsAttribute(ATTRIBUTE_FIRE)
end
function c1625.thfilter(c)
	return ((c:IsRace(RACE_SPELLCASTER) and c:IsDefense(1500)) or (c:IsAttack(1500) and c:IsDefense(200))) 
		and c:IsAbleToHand()
end
function c1625.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1625.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1625.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1625.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

