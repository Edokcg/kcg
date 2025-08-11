--不死之元素英雄 爆热女郎(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.spcon2)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
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
