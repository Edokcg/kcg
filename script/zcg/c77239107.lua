--神石板 天空龙
function c77239107.initial_effect(c)
	--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c77239107.atkcon)
	e8:SetTarget(c77239107.atktg)
	e8:SetOperation(c77239107.atkop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c77239107.atkfilter(c,e,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP_ATTACK) and (not e or c:IsRelateToEffect(e))
end
function c77239107.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77239107.atkfilter,1,nil,nil,1-tp)
end
function c77239107.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function c77239107.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c77239107.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:GetAttack()==0 then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
