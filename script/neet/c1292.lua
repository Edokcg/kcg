--闪刀姬-灼乌
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,63288573,aux.FilterBoolFunction(s.ffilter),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
	--cannot link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetCondition(s.linkcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--decrease atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(-1500)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--attack all
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ATTACK_ALL)
	e6:SetValue(s.atkfilter)
	c:RegisterEffect(e6)
end
function s.linkcon(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) 
end
function s.chainfilter(re,tp)
	return not (re:GetHandler():IsSetCard(0x115)) and re:IsActiveType(TYPE_SPELL)
end
function s.ffilter(c)
	return not c:IsAttribute(ATTRIBUTE_FIRE) and  c:IsSetCard(0x1115)   
end
function s.ffilter1(c)
	return c:IsCode(63288573) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function s.rfilter(c,fc)
	return (s.ffilter1(c) or (not c:IsAttribute(ATTRIBUTE_FIRE) and  c:IsSetCard(0x1115)))
		and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function s.spfilter1(c,tp,g)
	return g:IsExists(s.spfilter2,1,c,tp,c)
end
function s.spfilter2(c,tp,mc)
	return (s.ffilter1(c) and (not mc:IsAttribute(ATTRIBUTE_FIRE) and  mc:IsSetCard(0x1115))
		or s.ffilter1(mc) and (not c:IsAttribute(ATTRIBUTE_FIRE) and  c:IsSetCard(0x1115)))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	return rg:IsExists(s.spfilter1,1,nil,tp,rg) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)~=0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=rg:FilterSelect(tp,s.spfilter1,1,1,nil,tp,rg)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=rg:FilterSelect(tp,s.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function s.atkfilter(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end