--六花圣 尾花絮(neet)
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PLANT),4,2)
	c:EnableReviveLimit()   
	--sp sum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e2:SetCountLimit(1,{id,0})
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_SINGLE)
	e2a:SetCode(EFFECT_MATERIAL_CHECK)
	e2a:SetValue(s.valcheck)
	e2a:SetLabelObject(e2)
	c:RegisterEffect(e2a) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,{id,1})
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)
end
s.listed_series={0x141}
function s.valcheck(e,c)
	local ct=c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x141,c,SUMMON_TYPE_XYZ,e:GetHandlerPlayer())
	e:GetLabelObject():SetLabel(ct)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x141) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter2(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft>ct then ft=ct end
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND,0,1,ct,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.rfilter(c,tp)
	return (c:IsControler(tp) or (c:IsControler(1-tp) and c:IsFaceup() and c:IsHasEffect(CARD_RIKKA_KONKON))) and c:IsMonster() and c:IsReleasable() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function s.thfilter(c,lv)
	return c:IsSetCard(0x141) and c:IsMonster() and c:IsLevel(lv) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return chkc:IsLocation(LOCATION_MZONE) and s.rfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,s.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	if tc and tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end