--超越靴
function c77239061.initial_effect(c)

    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)	
    e1:SetCondition(c77239061.condition)
    e1:SetTarget(c77239061.target)
    e1:SetOperation(c77239061.activate)
    c:RegisterEffect(e1)
end
function c77239061.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77239061.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsDestructable() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c77239061.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    local atk=tc:GetAttack()
    local def=tc:GetDefense()
	if tc:IsRelateToEffect(e) --[[and tc:IsAttackable()]] and not tc:IsStatus(STATUS_ATTACK_CANCELED) and atk>def then
		Duel.Destroy(tc,REASON_EFFECT)
        Duel.Damage(1-tp,atk-def,REASON_EFFECT)		
	end
end
