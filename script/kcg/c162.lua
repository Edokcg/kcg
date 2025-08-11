--Ｎ・Ａｓ・Ｈ Ｋｎｉｇｈｔ
--Nafil Asylum Heth Knight
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,nil,5,2)
	c:EnableReviveLimit()

	--Cannot be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	--Attach 1 "Number" monster and 1 other monster to itself
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e2:SetCost(s.cost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.attop)
	c:RegisterEffect(e2)
end
s.listed_series={0x48}

function s.indcon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x48),0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local count=0
	if e:GetHandler():RemoveOverlayCard(tp,#g,#g,REASON_COST) then
		count=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)
	end
	e:SetLabel(count)
end
function s.attfilter1(c,e,tp)
	local no=c.xyz_number
	return no and no>=101 and no<=107 and c:IsSetCard(0x48) and c:IsType(TYPE_XYZ) 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.attfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_EXTRA)
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)
	if ft<=0 or ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	ft=math.min(ft,aux.CheckSummonGate(tp) or ft)
	ft=math.min(ft,ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.attfilter1,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp)
	if #g>0 then
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end