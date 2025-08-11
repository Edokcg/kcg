--装甲 墓械城大炮 （ZCG）
function c77240289.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240289,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c77240289.target)
	e1:SetOperation(c77240289.operation)
	c:RegisterEffect(e1)
end
function c77240289.filter(c,e,sp)
	return c:IsSetCard(0xa110) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c77240289.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c77240289.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c77240289.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240289.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	if g:GetCount()>0 then
	   local tc=g:GetFirst()
	   while tc do 
	   local e3=Effect.CreateEffect(e:GetHandler())
	   e3:SetType(EFFECT_TYPE_SINGLE)
	   e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	   e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	   e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	   tc:RegisterEffect(e3)
	   tc=g:GetNext()
	end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end











