--奥西里斯的统治者 （ZCG）
function c77240255.initial_effect(c)
 c:SetUniqueOnField(1,1,77240255,LOCATION_MZONE)
	--immune effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetValue(c77240255.efilter)
	c:RegisterEffect(e4)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240255,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c77240255.condition1)
	e1:SetOperation(c77240255.operation1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240255,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c77240255.condition2)
	e2:SetOperation(c77240255.operation2)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240255,2))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c77240255.condition3)
	e3:SetOperation(c77240255.operation3)
	c:RegisterEffect(e3)
end
function c77240255.cfilter1(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsType(TYPE_SPELL)
end
function c77240255.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77240255.cfilter1,1,nil,tp)
end
function c77240255.cfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsType(TYPE_TRAP)
end
function c77240255.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77240255.cfilter2,1,nil,tp)
end
function c77240255.cfilter3(c,tp)
	return c:GetPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER)
end
function c77240255.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77240255.cfilter3,1,nil,tp)
end
function c77240255.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c77240255.filter1(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c77240255.filter2(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c77240255.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if bit.band(tpe,TYPE_FIELD)~=0 then
			local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if of then Duel.Destroy(of,REASON_RULE) end
			of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		end
		if bit.band(tpe,TYPE_FIELD)~=0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			tc:CancelToGrave(false)
		end
		if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		if etc then
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	end
end
function c77240255.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c77240255.filter1,tp,0,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,1,nil) or not Duel.IsExistingMatchingCard(c77240255.filter2,tp,0,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,1,nil) then return end
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_DECK)
	Duel.ConfirmCards(tp,g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local t1=Duel.SelectMatchingCard(tp,c77240255.filter1,tp,0,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,1,1,nil)
	if not t1 then return end
	local t2=Duel.SelectMatchingCard(tp,c77240255.filter2,tp,0,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,1,1,nil)
	if not t2 then return end
	t1:Merge(t2)
	Duel.SendtoHand(t1,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,t1)
	Duel.ShuffleHand(1-tp)
end
function c77240255.operation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_BATTLE_START)
    e6:SetTarget(c77240255.destg)
    e6:SetOperation(c77240255.desop)
    c:RegisterEffect(e6)
end
function c77240255.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc and tc:IsFaceup() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c77240255.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    local atk=tc:GetAttack()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() then
        Duel.Destroy(tc,REASON_RULE,LOCATION_REMOVED)
        Duel.Recover(tp,atk,REASON_EFFECT)
    end
end
