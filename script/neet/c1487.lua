--自然的神星兽(neet)
Duel.LoadScript("neet.lua")
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	--summon cannot be negated
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.synchrouselink=true
s.synchrouserank=true
local TYPES=TYPE_RITUAL|TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK 
local function getcount(c)
	local g=c:GetMaterial()
	return g:GetBinClassCount(function(c) return c:GetType()&TYPES end)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=getcount(e:GetHandler())
	e:SetLabel(ct)
	local loc1,loc2=0,0
	if ct>0 then loc1=loc1+LOCATION_SZONE loc2=loc2+LOCATION_SZONE end
	if ct>1 then loc1=loc1+LOCATION_GRAVE loc2=loc2+LOCATION_GRAVE end
	if ct>3 then loc1=loc1+LOCATION_HAND loc2=loc2+LOCATION_HAND end
	if ct>4 then loc2=loc2+LOCATION_EXTRA end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,loc1,loc2,nil)
	local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if ct>2 then sg:Merge(mg) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local loc1,loc2=0,0
	if ct>0 then loc1=loc1+LOCATION_SZONE loc2=loc2+LOCATION_SZONE end
	if ct>1 then loc1=loc1+LOCATION_GRAVE loc2=loc2+LOCATION_GRAVE end
	if ct>3 then loc1=loc1+LOCATION_HAND loc2=loc2+LOCATION_HAND end
	if ct>4 then loc2=loc2+LOCATION_EXTRA end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,loc1,loc2,nil)
	local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if ct>2 then sg:Merge(mg) end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end