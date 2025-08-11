--三国传-曹操
function c77238651.initial_effect(c)
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77238651.adval)
    c:RegisterEffect(e1)
	
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCondition(c77238651.retcon)
    --e2:SetCost(c77238651.cost)
    e2:SetOperation(c77238651.sumop)
    c:RegisterEffect(e2)
end
----------------------------------------------------------------------
function c77238651.adval(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_GRAVE)*300
end
----------------------------------------------------------------------
function c77238651.retcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
--[[function c77238651.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
      (Duel.IsExistingMatchingCard(c77238651.filter,tp,LOCATION_ONFIELD,0,1,nil) or
	  Duel.IsExistingMatchingCard(c77238651.filter,tp,LOCATION_HAND,0,2,nil)) and
	  c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)	
end
function c77238651.sumop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77238651.filter,tp,LOCATION_ONFIELD,0,nil)
    local g1=Duel.GetMatchingGroup(c77238651.filter,tp,LOCATION_HAND,0,nil)	
	if g:GetCount()>0 and g1:GetCount()>1 then
	    local op=Duel.SelectOption(tp,aux.Stringid(77238651,0),aux.Stringid(77238651,1))
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(tp,c77238651.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=Duel.SelectMatchingCard(tp,c77238651.filter,tp,LOCATION_HAND,0,2,2,nil)			
		end
	elseif g:GetCount()>0 and g1:GetCount()<2 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c77238651.filter,tp,LOCATION_ONFIELD,0,1,1,nil)	
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c77238651.filter,tp,LOCATION_HAND,0,2,2,nil)	
	end	
    if rg:GetCount()>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 and e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end]]
function c77238651.filter(c)
    return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa300)
end
--[[function c77238651.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77238651.filter,tp,LOCATION_MZONE,0,1,nil) end
end]]
function c77238651.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local op=Duel.SelectOption(tp,aux.Stringid(77238651,0),aux.Stringid(77238651,1))
		if op==0 then
			local g=Duel.SelectMatchingCard(tp,c77238651.filter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Remove(g,POS_FACEUP,REASON_COST)
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		else
			local g=Duel.SelectMatchingCard(tp,c77238651.filter,tp,LOCATION_HAND,0,2,2,nil)
			Duel.Remove(g,POS_FACEUP,REASON_COST)
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end