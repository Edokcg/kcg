--地狱之天空龙(Z)
function c77239104.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c77239104.ttcon)
	e1:SetOperation(c77239104.ttop)
	--e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c77239104.setcon)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)

	--atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c77239104.adval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	
	--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c77239104.atkcon)
	e8:SetTarget(c77239104.atktg)
	e8:SetOperation(c77239104.atkop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	
	--不会被效果破坏
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e10:SetValue(1)
    c:RegisterEffect(e10)
	
    --不会被战斗破坏
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e11:SetValue(1)
    c:RegisterEffect(e11)
	
	--战斗伤害为0
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e12:SetValue(1)
    c:RegisterEffect(e12)
end
------------------------------------------------------------------
function c77239104.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239104.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c77239104.setcon(e,c,minc)
	if not c then return true end
	return false
end
------------------------------------------------------------------
function c77239104.adval(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)*1000
end

function c77239104.atkfilter(c,e,tp)
	return c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c77239104.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77239104.atkfilter,1,nil,nil,1-tp)
end
function c77239104.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function c77239104.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c77239104.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
    local atk=tc:GetAttack()	
	while tc do
		local preatk=tc:GetAttack()
        local predef=tc:GetDefense()		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-4000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(-4000)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)		
		if (preatk~=0 or predef~=0) and (tc:GetAttack()==0 or tc:GetDefense()==0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
	Duel.Damage(1-tp,4000-atk,REASON_EFFECT)
end
