--上古红龙(ZCG)
local s,id=GetID()
function s.initial_effect(c)
--
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
--
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(s.ttcon)
	e1:SetOperation(s.ttop)
	e1:SetValue(SUMMON_TYPE_TRIBUTE)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
--
	local e3 = Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE + PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.ctcon)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
	--aclimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetOperation(s.regop)
	c:RegisterEffect(e6)
								   --immue 
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(EFFECT_IMMUNE_EFFECT)
	e17:SetRange(LOCATION_MZONE)
	e17:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e17:SetTarget(s.tger)
	e17:SetValue(s.efilter)
	c:RegisterEffect(e17)
	local e18=e17:Clone()
	e18:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e18:SetValue(s.indes)
	c:RegisterEffect(e18)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)   
	e1:SetOperation(s.winop)
	e1:SetCountLimit(1)
	e1:SetLabel(0) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	Duel.RegisterEffect(e1,tp)
end
function s.winop(e)
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	if ct>=5 then
	Duel.Win(e:GetHandler():GetControler(),0x13)
	end
end
function s.ctcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() == 1-tp
end
function s.ctop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local opt=Duel.SelectOption(1-tp,aux.Stringid(id,4),aux.Stringid(id,5))
	if opt==0 then
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_MUST_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_BATTLE)
	c:RegisterEffect(e3)
	else
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCode(EFFECT_SKIP_DP)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SKIP_SP)
	Duel.RegisterEffect(e5,tp)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SKIP_M1)
	Duel.RegisterEffect(e6,tp)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_EP)
	Duel.RegisterEffect(e7,tp)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BP)
	Duel.RegisterEffect(e8,tp)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_SKIP_BP)
	Duel.RegisterEffect(e9,tp)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_SKIP_M2)
	Duel.RegisterEffect(e10,tp)
end
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)  then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return rp==1-tp
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	if opt==0 then
		Duel.PayLPCost(1-tp,1000)
	else
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
function s.otfilter(c, tp)
	return c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER)
end

function s.ttcon(e, c, minc)
	if c == nil then
		return true
	end
	local tp = c:GetControler()
	local mg = Duel.GetMatchingGroup(s.otfilter, tp, LOCATION_MZONE, 0, nil, tp)
	return minc <= 1 and Duel.CheckTribute(c, 3, 99, mg)
end

function s.ttop(e, tp, eg, ep, ev, re, r, rp, c)
	local mg = Duel.GetMatchingGroup(s.otfilter, tp, LOCATION_MZONE, 0, nil, tp)
	local sg = Duel.SelectTribute(tp, c, 3, 99, mg)
	c:SetMaterial(sg)
	Duel.Release(sg, REASON_SUMMON + REASON_MATERIAL)
end

function s.indes(e,c)
	return not (c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER))
end
function s.tger(e,c)
	return c:IsSetCard(0xa120)
end
function s.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xa120) and te:IsActiveType(TYPE_MONSTER)
end