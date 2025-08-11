--Glorious Seven
function c11370078.initial_effect(c)
	--act qp in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(c11370078.condition)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c11370078.target)
	e1:SetOperation(c11370078.activate)
	c:RegisterEffect(e1)
end
function c11370078.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c11370078.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11370078.filter(chkc) end
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_GRAVE)
		and Duel.IsExistingTarget(c11370078.filter,tp,LOCATION_MZONE,0,1,nil) and
			Duel.IsExistingMatchingCard(c11370078.filter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c11370078.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11370078.filter2(c,e,tp)
	local no=c.xyz_number
	return no and no>=101 and no<=107 and c:IsSetCard(0x1048)
end
function c11370078.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
      if tc==nil then return end
	g=Duel.GetMatchingGroup(c11370078.filter2,tp,LOCATION_REMOVED,0,c)
	Duel.Overlay(tc,g)
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END) 
	e1:SetValue(1)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
      e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END) 
	tc:RegisterEffect(e2)
	--SetLP
	local lp1=Duel.GetLP(1-tp)*1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(lp1)
	e1:SetOperation(c11370078.thop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e1,tp)
end

function c11370078.thop(e,tp,eg,ep,ev,re,r,rp)
	lp1=e:GetLabel()
	local lp2=Duel.GetLP(1-tp)
	if lp1~=lp2 then
			local dif=(lp1>lp2) and (lp1-lp2) or (lp2-lp1)
	Duel.SetLP(tp,dif,REASON_EFFECT)
	else
	Duel.SetLP(tp,0,REASON_EFFECT)
end
end

function c11370078.filter3(c,e,tp)
	return (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
end
function c11370078.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return tp~=Duel.GetTurnPlayer() 
and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) 
--and ph==PHASE_BATTLE
and Duel.IsExistingMatchingCard(c11370078.filter3,tp,LOCATION_MZONE,0,1,nil)
end
