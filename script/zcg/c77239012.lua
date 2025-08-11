--念动力低气压
function c77239012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c77239012.condition)
	e1:SetTarget(c77239012.target)
	e1:SetOperation(c77239012.activate)
	c:RegisterEffect(e1)
end
function c77239012.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77239012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsDestructable() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c77239012.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) --[[and tc:IsAttackable()]] and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.Destroy(tc,REASON_EFFECT)
		local sg=Duel.GetMatchingGroup(c77239012.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	    Duel.SendtoHand(sg,nil,REASON_EFFECT)
	    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	    if g:GetCount()==0 then return end		
		local rt=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
        local sg=g:Select(1-tp,rt,rt,nil)
        Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)		
	end
end
