--不死之卫兵骑士(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
 -- spsummon
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_LEAVE_FIELD)
	if aux.IsKCGScript then
	   e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	else
	   e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	end
	e1:SetCondition(s.drcon)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.drop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_PHASE + PHASE_STANDBY)
		e1:SetCondition(s.spcon)
		e1:SetOperation(s.spop)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_STANDBY + RESET_SELF_TURN, 1)
		e1:SetLabel(-1)
		c:RegisterEffect(e1)
		c:CreateEffectRelation(e1)
	end
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() == tp
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local ct = e:GetLabel()
	if ct < 1 then
		ct = ct + 1
		e:SetLabel(ct)
		return
	end
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then
		return
	end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
	end
end
