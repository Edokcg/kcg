--转移
function c77239065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c77239065.condition)
	e2:SetTarget(c77239065.target)
	e2:SetOperation(c77239065.activate)
	c:RegisterEffect(e2)
end
function c77239065.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77239065.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
end
function c77239065.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsRelateToEffect(e) and Duel.NegateAttack() then
        Duel.GetControl(tc,tp,0,0)
    end
end