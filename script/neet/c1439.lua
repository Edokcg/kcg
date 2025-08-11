--神·史莱姆·Ⅱ（neet）
local s,id=GetID()
function s.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_AQUA),s.matfilter)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
	--triple tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRIPLE_TRIBUTE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
 --limit attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTarget(s.atktg)
	c:RegisterEffect(e3)
  --cannot activate
	local e24=Effect.CreateEffect(c)
	e24:SetType(EFFECT_TYPE_FIELD)
	e24:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e24:SetCode(EFFECT_CANNOT_ACTIVATE)
	e24:SetRange(LOCATION_MZONE)
	e24:SetTargetRange(1,1)
	e24:SetValue(s.aclimit)
	c:RegisterEffect(e24)
end
s.listed_names={id}
function s.matfilter(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_WATER,fc,sumtype,tp) and c:GetLevel()==10
end
function s.hspfilter(c,tp,sc)
	return c:IsRace(RACE_AQUA) and c:GetLevel()==10 and c:GetAttack()==0 and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,s.hspfilter,1,false,1,true,c,tp,nil,nil,nil,tp,c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectReleaseGroup(tp,s.hspfilter,1,1,false,true,true,c,tp,nil,false,nil,tp,c)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
	g:DeleteGroup()
end
function s.atktg(e,c)
	return c:GetAttack()<e:GetHandler():GetAttack()
end
function s.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttack()<e:GetHandler():GetAttack()
end

