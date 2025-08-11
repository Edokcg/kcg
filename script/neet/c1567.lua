--剑之追击(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,{id,0})
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)	
end
s.listed_series={0x100d}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x100d) and c:GetAttackedCount()>0 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_MZONE,0,nil)
	local b1=ct>0 and Duel.IsPlayerCanDraw(tp,ct)
	local b2=ct>0 and Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,0,nil)>=ct
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(ct)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	else
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetTargetParam(ct)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,ct,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	else
		local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,d,d,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_SKIP_M2)
	e0:SetTargetRange(1,0)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end