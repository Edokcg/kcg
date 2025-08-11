--殉道者之神女的诱惑（ZCG）
function c77240223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_CHAIN_END+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240223,0))
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DRAW)
	e2:SetCountLimit(1)
	e2:SetCondition(c77240223.condition)
	e2:SetOperation(c77240223.activate)
	c:RegisterEffect(e2)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c77240223.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(0,LOCATION_ONFIELD)
	e12:SetTarget(c77240223.distg9)
	c:RegisterEffect(e12)
end
function c77240223.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function c77240223.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end
function c77240223.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and r==REASON_RULE
end
function c77240223.dfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c77240223.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(tp,tc)
		if tc:IsType(TYPE_MONSTER) and  tc:IsCanBeSpecialSummoned(e,0,tp,true,false) and  Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		
	else
		Duel.ShuffleHand(1-tp)
	end
end
end