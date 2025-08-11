--奥利哈刚镜子骑士(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  c:EnableReviveLimit()
   --Special Summon Tokens
   local e1=Effect.CreateEffect(c)
   e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
   e1:SetCode(EVENT_SPSUMMON_SUCCESS)
   e1:SetCondition(s.spcon)
   e1:SetTarget(s.target)
   e1:SetOperation(s.operation)
   c:RegisterEffect(e1)
 --Attribute Dark
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(0x0)
	c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77240476,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_WARRIOR,0x0) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,98710524,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_WARRIOR,0x0) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local fid=e:GetHandler():GetFieldID()
	local g=Group.CreateGroup()
	for i=1,ft do
		local token=Duel.CreateToken(tp,77240476)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	e5:SetReset(RESET_EVENT+0x1fe0000)
	e5:SetCondition(s.imcon)
	token:RegisterEffect(e5)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(0x0)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e3)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		e2:SetCondition(s.atkcon)
		e2:SetOperation(s.atkop)
		token:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function s.cfilter2(c)
	return c:IsCode(77240476)
end
function s.imcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(bc:GetAttack())
	e:GetHandler():RegisterEffect(e1)
end