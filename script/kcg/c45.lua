--ネオス·ワイズマン
function c45.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,89943723,78371393,true,true)

	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	--damage&recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5126490,0))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetTarget(c45.damtg)
	e3:SetOperation(c45.damop)
	c:RegisterEffect(e3)

	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5438492,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetTarget(c45.sptg)
	e4:SetOperation(c45.spop)
	c:RegisterEffect(e4)
end
c45.listed_names={CARD_NEOS,78371393}

function c45.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c45.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,bc:GetDefense())
end
function c45.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local atk=bc:GetAttack()
	local def=bc:GetDefense()
	if atk<0 then atk=0 end
	if def<0 then def=0 end
	if Duel.Damage(1-tp,atk,REASON_EFFECT)>0 then
	Duel.Recover(tp,def,REASON_EFFECT) end
end

function c45.spfilter(c,e,tp)
	local code=c:GetCode()
	return code==89943723 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c45.spfilter2(c)
	local code=c:GetCode()
	return code==78371393 and c:IsAbleToRemoveAsCost()
end
function c45.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c45.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c45.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
			and Duel.IsExistingTarget(c45.spfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	  local r=Duel.SelectMatchingCard(tp,c45.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	  if #r<1 then return end
	  Duel.Remove(r,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c45.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c45.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
