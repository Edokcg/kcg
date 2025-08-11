--新空间进化选择(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(s.reptg2)
	e3:SetOperation(s.repop2)
	e3:SetValue(s.repval2)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_NEOS}
s.listed_series={0x1f}
function s.filter1(c,e,tp)
	return c:IsSetCard(0x1f) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.filter2(c,e,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,fc,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:ListsCodeAsMaterial(fc:GetCode())
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<1 then return end
	local fc=e:GetLabelObject()
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,fc)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function s.repfilter2(c,tp,re)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:ListsCodeAsMaterial(CARD_NEOS) and c:IsType(TYPE_FUSION)
		and c:GetDestination()==LOCATION_DECK and re:GetOwner()==c
end
function s.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re
		and e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter2,1,nil,tp,re) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,0)) then
		return true
	else return false end
end
function s.repop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function s.repval2(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and c:ListsCodeAsMaterial(CARD_NEOS) and c:IsType(TYPE_FUSION)
end