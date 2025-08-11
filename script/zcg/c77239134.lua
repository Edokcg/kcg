--青眼白龙圣骑士(ZCG)
function c77239134.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCodeRep(c,89631139,2,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77239134.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c77239134.spcon)
	e2:SetOperation(c77239134.spop)
	c:RegisterEffect(e2)

	--除外
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(77239134,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetTarget(c77239134.destg)
	e3:SetOperation(c77239134.desop)
	c:RegisterEffect(e3)	
end
--------------------------------------------------------------------------------
function c77239134.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77239134.spfilter(c,fc)
	return c:IsCode(89631139)  and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function c77239134.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239134.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,nil,c)
end
function c77239134.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c77239134.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,2,nil,c)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end
--------------------------------------------------------------------------------
function c77239134.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c77239134.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end


