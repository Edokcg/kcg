--原始昆虫 虫王之卵LV2(ZCG)
local s,id=GetID()
function s.initial_effect(c)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.otcon)
	e1:SetOperation(s.otop)
	c:RegisterEffect(e1)
		--
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(s.efilter)
	c:RegisterEffect(e11)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end
function s.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te) and ec:GetControler()~=c:GetControler()
end
function s.otfilter(c,tp)
	return c:IsCode(77240439) and c:IsControler(tp)
end
function s.otcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_MZONE,0,nil,tp)
	return mg:GetCount()>0
end
function s.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_MZONE,0,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	Duel.Release(sg,REASON_COST)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.filter(c,e,sp)
	return c:IsLevelBelow(5) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
