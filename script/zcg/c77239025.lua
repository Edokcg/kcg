--黑暗之复活
function c77239025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77239025.target)
	e1:SetOperation(c77239025.activate)
	c:RegisterEffect(e1)
end
function c77239025.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239025.dfilter(c,atk)
    return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c77239025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c77239025.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77239025.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77239025.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    local tc=g:GetFirst()
    local dg=Duel.GetMatchingGroup(c77239025.dfilter,tp,0,LOCATION_MZONE,nil,tc:GetBaseAttack())
    if dg:GetCount()>0 then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
    end	
end
function c77239025.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
	    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local dg=Duel.SelectMatchingCard(tp,c77239025.dfilter,tp,0,LOCATION_MZONE,1,1,nil,tc:GetBaseAttack())
        Duel.Destroy(dg,REASON_EFFECT)				
	end
end