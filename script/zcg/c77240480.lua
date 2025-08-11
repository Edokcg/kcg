--奥利哈刚 西洛诺斯左腕(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		 c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.cbcon)
	e2:SetOperation(s.cbop)
	c:RegisterEffect(e2)
	--Shunoros Debuf
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--atklimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetCondition(s.atkcon)
	c:RegisterEffect(e4)
end
function s.afilter(c)
	return c:IsCode(id-2)
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.afilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end

function s.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.cbop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
Duel.ChangeAttackTarget(c)
local b=Duel.GetAttacker()
local def=b:GetAttack()+300
e:SetLabel(def)
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_SINGLE)
e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
e1:SetValue(def)
e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(id-2) and c:GetAttack()~=0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-e:GetHandler():GetDefense())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
