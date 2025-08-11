--无名-传说之心
function c77239499.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode3(c,77239496,77239497,77239498,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)	
	
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239499,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c77239499.con)
	e2:SetTarget(c77239499.target)
	e2:SetOperation(c77239499.activate)
	c:RegisterEffect(e2)
	
	--double
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c77239499.damcon)
	e3:SetOperation(c77239499.damop)
	c:RegisterEffect(e3)

	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c77239499.atkcon)   
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetOperation(c77239499.op)
	c:RegisterEffect(e5)	
end
-------------------------------------------------------------------
function c77239499.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77239499.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239499.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77239499.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c77239499.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239499.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77239499.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
-------------------------------------------------------------------
function c77239499.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c77239499.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
-------------------------------------------------------------------
function c77239499.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(77239499)==0
end
function c77239499.op(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(77239499,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end


