--召雷弹(ZCG)
function c77239198.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

	--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c77239198.atkcon)
	e8:SetTarget(c77239198.atktg)
	e8:SetOperation(c77239198.atkop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
    e10:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e10)
end
function c77239198.atkfilter(c,e,tp)
	return c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c77239198.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77239198.atkfilter,1,nil,nil,1-tp)
end
function c77239198.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function c77239198.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c77239198.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local predef=tc:GetDefense()		
        if tc:IsFaceup() and tc:IsAttackPos()	then	
		    local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_UPDATE_ATTACK)
		    e1:SetValue(-2000)
		    e1:SetReset(RESET_EVENT+0x1fe0000)
		    tc:RegisterEffect(e1)
        elseif tc:IsFaceup() and tc:IsDefensePos()	then
		    local e2=Effect.CreateEffect(c)
		    e2:SetType(EFFECT_TYPE_SINGLE)
		    e2:SetCode(EFFECT_UPDATE_DEFENSE)
		    e2:SetValue(-2000)
		    e2:SetReset(RESET_EVENT+0x1fe0000)
		    tc:RegisterEffect(e2)
		end
		if (preatk~=0 or predef~=0) and (tc:GetAttack()==0 or tc:GetDefense()==0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
