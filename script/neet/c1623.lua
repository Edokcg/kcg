--古代的素材
function c1623.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c1623.cost)
	e1:SetTarget(c1623.target)
	e1:SetOperation(c1623.activate)
	c:RegisterEffect(e1)
end
function c1623.costfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x7) and c:IsType(TYPE_MONSTER) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetOriginalCode(),0,TYPES_NORMAL_TRAP_MONSTER,c:GetAttack(),c:GetDefense(),c:GetOriginalLevel(),RACE_MACHINE,ATTRIBUTE_EARTH)
end
function c1623.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1623.costfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c1623.costfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	e:SetLabel(tc:GetOriginalCode(),tc:GetAttack(),tc:GetDefense(),tc:GetOriginalLevel())
	Duel.SendtoGrave(tc,REASON_COST)
end
function c1623.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1623.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local code,atk,def,lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,code,0,TYPES_NORMAL_TRAP_MONSTER,atk,def,lv,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP,0,0,lv,atk,def)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(code)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	Duel.c:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
end





