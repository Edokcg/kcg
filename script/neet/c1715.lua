--英雄少年（neet）
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x8),1,99,s.mfilter)
--Fusion Materials check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.matcheck)
	c:RegisterEffect(e2)
--indes
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e20:SetValue(1)
	c:RegisterEffect(e20)
--multi
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
s.listed_series={0x3008,0xc008,0x6008,0xa008}
s.material_setcode={0x8}
function s.mfilter(c,fc,sumtype,tp)
	return c:IsCode(32679370) 
end
function s.matcheck(e,c)
	local g=c:GetMaterial()
	--Increase ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(#g*800)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	c:RegisterEffect(e1)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetCondition(s.con1)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
  --attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(s.atkfilter)
	e3:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	e3:SetCondition(s.con3)
	c:RegisterEffect(e3)
--Banish cards sent to GY
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e10:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTarget(s.rmtarget)
	e10:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	e10:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e10:SetCondition(s.con4)
	e10:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e10)
end
function s.cfilter2(c,fc)
	return c:IsSetCard(0x3008)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return g and g:IsExists(s.cfilter2,1,nil)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return g and g:IsExists(Card.IsSetCard,1,nil,0xc008)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return g and g:IsExists(Card.IsSetCard,1,nil,0x6008)
end
function s.atkfilter(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return g and g:IsExists(Card.IsSetCard,1,nil,0xa008)
end
function s.rmtarget(e,c)
	return Duel.IsPlayerCanRemove(e:GetHandlerPlayer(),c) and c:GetOwner()~=e:GetHandlerPlayer()
end