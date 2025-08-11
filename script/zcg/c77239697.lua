--电子龙 终结之月(ZCG)
function c77239697.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,c77239697.xyzfilter,10,2)
	c:EnableReviveLimit()
	
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239697,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c77239697.eqtg)
	e1:SetOperation(c77239697.eqop)
	c:RegisterEffect(e1)

	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239697,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)  
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c77239697.cost)
	e2:SetTarget(c77239697.target)
	e2:SetOperation(c77239697.operation)
	c:RegisterEffect(e2)	
	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77239697,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c77239697.cost1)
	e3:SetTarget(c77239697.target1)
	e3:SetOperation(c77239697.operation1)
	c:RegisterEffect(e3)	
end
--------------------------------------------------------------------------------------
function c77239697.xyzfilter(c)
	return c:IsSetCard(0x93) or c:IsSetCard(0x1093)
end
--------------------------------------------------------------------------------------
function c77239697.filter(c)
	return (c:IsSetCard(0x93) or c:IsSetCard(0x1093)) and c:IsType(TYPE_MONSTER)
end
function c77239697.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c77239697.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c77239697.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c77239697.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77239697.eqlimit(e,c)
	return e:GetOwner()==c
end
function c77239697.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()/2
			if tc:IsFacedown() then atk=0 end
			if atk<0 then atk=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c77239697.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				tc:RegisterEffect(e2)
			end
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
--------------------------------------------------------------------------------------
function c77239697.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239697.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c77239697.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(math.ceil(atk*2))
		tc:RegisterEffect(e1)
		if tc==e:GetHandler() then
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(77239697,0))
			e2:SetCategory(CATEGORY_DESTROY)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCountLimit(1)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetTarget(c77239697.tgtg)
			e2:SetOperation(c77239697.tgop)
			c:RegisterEffect(e2)
		end
	end
end
function c77239697.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c77239697.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
--------------------------------------------------------------------------------------
function c77239697.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetFlagEffect(tp,77239697)==0 end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	Duel.RegisterFlagEffect(tp,77239697,0,0,0)	  
end
function c77239697.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239697.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
