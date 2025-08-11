--闇黑羽翼龍 (KA)
local s,id=GetID()
function s.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LVCHANGE)	 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.ptg)
	e2:SetOperation(s.pop)
	c:RegisterEffect(e2) 
end
s.listed_series={0x316}

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x316)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.filter1(c,tp)
	local lv1=0
	if c:GetLevel()>0 then lv1=c:GetLevel() end
	return lv1>0 and c:IsFaceup() and Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,lv1)
end
function s.filter2(c,lv1)
	local lv2=c:GetLevel()
	return lv2>0 and lv2~=lv1 and c:IsFaceup()
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.filter1(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26864586,0))
	local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	local lv1=0
	if tc1:GetLevel()>0 then
	lv1=tc1:GetLevel() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc2=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc1,lv1):GetFirst()
	local lv=tc2:GetLevel()
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc1:RegisterEffect(e1)
	end
end
