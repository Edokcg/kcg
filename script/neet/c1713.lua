--娱乐伙伴 异色眼围巾虎（neet）
local s,id=GetID()
function s.initial_effect(c)
--pendulum summon
	Pendulum.AddProcedure(c,false)
--Activate
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(1160)
	e10:SetType(EFFECT_TYPE_ACTIVATE)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_HAND)
	e10:SetCost(s.reg)
	c:RegisterEffect(e10)
	--Synchro limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(s.synlimit)
	c:RegisterEffect(e1)
-- to extra
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(s.thcon)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
--Gain ATK/DEF
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.atkcon)
	e5:SetValue(c:GetBaseAttack()*2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE)
	e6:SetValue(c:GetBaseDefense()*2)
	c:RegisterEffect(e6)
 -- Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,{id,2})
	e3:SetCondition(s.drcon)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end
s.listed_series={0x9f}
function s.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.synlimit(e,c)
	if not c then return false end
	return not c:IsType(TYPE_PENDULUM)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x9f) and not c:IsForbidden()
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		local g=Duel.SelectMatchingCard(tp,s.tefilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.SendtoExtraP(g,tp,REASON_EFFECT)
		else
			local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			Duel.SendtoGrave(g2,REASON_EFFECT)
		end
	end
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsRace,RACE_FIEND),e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.posfilter(c)
	return  c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x9f) 
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) 
		and Duel.IsExistingTarget(s.posfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	local g2=Duel.SelectTarget(tp,s.posfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g2,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_TOEXTRA)
	if tg1:GetFirst() and tg1:GetFirst():IsRelateToEffect(e) and Duel.Destroy(tg1,REASON_EFFECT)>0
		and tg2:GetFirst() and tg2:GetFirst():IsRelateToEffect(e) then
		Duel.SendtoExtraP(tg2,tp,REASON_EFFECT)
	end
end