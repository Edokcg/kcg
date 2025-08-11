--给冥界的报酬(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCountLimit(1)
	e9:SetTarget(s.damtg)
	e9:SetOperation(s.damop)
	c:RegisterEffect(e9)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return g>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(g*100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,g*100)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end 