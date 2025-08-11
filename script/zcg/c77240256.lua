--奥西里斯之王 （ZCG）
function c77240256.initial_effect(c)
  --attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
 --cannot diratk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240256,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c77240256.operation)
	c:RegisterEffect(e3)
 --destroy
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BATTLE_CONFIRM)
	e0:SetTarget(c77240256.targ)
	e0:SetOperation(c77240256.op)
	c:RegisterEffect(e0)
 --recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77240256,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c77240256.reccon)
	e4:SetTarget(c77240256.rectg)
	e4:SetOperation(c77240256.recop)
	c:RegisterEffect(e4)
end
function c77240256.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c77240256.filter(c,e,tp)
	return c:IsSetCard(0xa100) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsType(TYPE_MONSTER)
end
function c77240256.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240256.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77240256.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240256.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c77240256.targ(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,t,1,0,0)
end
function c77240256.op(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() then
		if Duel.Destroy(t,REASON_EFFECT+REASON_RULE)~=0 then 
		local g=Duel.GetOperatedGroup()
		if Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)>=#g then
		local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_HAND,#g,#g,nil)
		Duel.Remove(hg,POS_FACEUP,REASON_EFFECT)
	end
	end
	end
end
function c77240256.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetValue(c77240256.efilter)
	c:RegisterEffect(e3)
end
function c77240256.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end