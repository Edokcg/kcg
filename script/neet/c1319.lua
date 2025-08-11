--双星神 伊沃夫（neet）
local s,id=GetID()
function s.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	c:RegisterEffect(e2)
	--summon cannot be negated
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--Remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(s.tdtg)
	e4:SetOperation(s.tdop)
	c:RegisterEffect(e4)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	return g:GetSum(Card.GetLink)>=13
end
function s.tdfilter(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local loc=LOCATION_MZONE+LOCATION_GRAVE
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,loc,loc,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,0)
	Duel.SetChainLimit(aux.FALSE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_MZONE+LOCATION_GRAVE
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,loc,loc,e:GetHandler())
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end