-- No.98 絶望皇ホープレス
local s, id = GetID()
function s.initial_effect(c)
	-- xyz summon
	Xyz.AddProcedure(c, aux.FilterBoolFunctionEx(Card.IsRace,RACE_WARRIOR), 5, 3)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(s.notcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	-- sp
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2, false, EFFECT_MARKER_DETACH_XMAT)
	-- battle indestructable
	local e6 = Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(s.indes)
	c:RegisterEffect(e6)
end
s.listed_series = {0x48}
s.xyz_number = 98
s.listed_names = {55470553}
function s.notcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x107f)
end
function s.xyzol(c)
	return c:IsRace(RACE_WARRIOR) and c:IsSetCard(0x48)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(s.xyzol,1,nil)
end
function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST)
	end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end
function s.filter(c)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) end
	if chk == 0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	   and Duel.IsExistingTarget(s.filter, tp, 0, LOCATION_GRAVE, 1, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, s.filter, tp, 0, LOCATION_GRAVE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 1-tp, LOCATION_GRAVE)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
	if
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
	Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
		--Cannot attack this turn
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3206)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		end
	end
end
function s.indes(e, c)
	return not c:IsSetCard(0x48)
end