--不死魔
function c77239042.initial_effect(c)
	--准备阶段特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)	
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(c77239042.condition)	
	e1:SetTarget(c77239042.target)
	e1:SetOperation(c77239042.operation)
	c:RegisterEffect(e1)
	
	--上升攻击力
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c77239042.val)
	c:RegisterEffect(e2)	
end
-----------------------------------------------------------------
function c77239042.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetTurnPlayer()==tp
end
function c77239042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239042.operation(e,tp,eg,ep,ev,re,r,rp)
   	local c=e:GetHandler()
	if  c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
------------------------------------------------------------------
function c77239042.val(e,c)
	return Duel.GetMatchingGroupCount(c77239042.filter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
function c77239042.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end

