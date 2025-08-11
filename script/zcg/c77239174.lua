--无敌流星龙(ZCG)
function c77239174.initial_effect(c)
	c:EnableReviveLimit()   
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77239174.spcon)
	e1:SetOperation(c77239174.spop)
	c:RegisterEffect(e1)
	
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(2)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTargetRange(0,1)
	e3:SetValue(c77239174.actlimit)
	c:RegisterEffect(e3)
	
	--不会被战斗破坏
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)

	--[[特殊召唤
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77239174,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,77239174+EFFECT_COUNT_CODE_OATH)
	e5:SetCondition(c77239174.con)
	e5:SetTarget(c77239174.sptg)
	e5:SetOperation(c77239174.spop1)
	c:RegisterEffect(e5)]]
	
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77239174,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(c77239174.sptg)
	e5:SetOperation(c77239174.spop1)
	c:RegisterEffect(e5)
end
------------------------------------------------------------------
function c77239174.spfilter(c)
	return c:IsCode(24696097) and c:IsAbleToRemoveAsCost()
end
function c77239174.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239174.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c77239174.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstMatchingCard(c77239174.spfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.SendtoGrave(tc,REASON_COST)
end
------------------------------------------------------------------
function c77239174.actlimit(e,te)
	return te:GetHandler():IsType(TYPE_TRAP+TYPE_SPELL)
end
------------------------------------------------------------------
function c77239174.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239174.filter(c,e,tp)
	return c:IsCode(24696097) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
--[[function c77239174.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239174.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77239174.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77239174.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end]]

function c77239174.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c77239174.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77239174.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77239174.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()   
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		--[[if not Duel.Equip(tp,c,tc,false) then return end
		aux.SetUnionState(c)]]
	end
end