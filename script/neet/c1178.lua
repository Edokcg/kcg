--古代的机械鲨(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,s.matfilter,1,1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--summon proc
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7))
	e4:SetCondition(s.sumcon)
	e4:SetOperation(s.sumop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
end
s.listed_series={0x7}
function s.matfilter(c,lc,sumtype,tp)
	return c:IsRace(RACE_MACHINE,lc,sumtype,tp) and not c:IsType(TYPE_LINK,lc,sumtype,tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp) and not c:IsLocation(LOCATION_DECK)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x7) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function s.sumcon(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	return ma>0 and e:GetHandler():IsAbleToRemove() and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local mi,ma=c:GetTributeRequirement()
	if mi<=2 and ma>=1 then
	  Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	  c:SetMaterial(Group.FromCards(e:GetHandler()))
	end
	if ma>=2 and mi<=2 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	   local sg=Duel.SelectReleaseGroup(tp,s.cfilter,1,1,nil,ft,tp)
	   Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)   
	   Duel.Release(sg,REASON_COST)
	   c:SetMaterial(nil)
	end
end