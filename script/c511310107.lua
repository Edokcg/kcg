--ダークネス・ブランブル
--Darkness Bramble
local s,id=GetID()
function s.initial_effect(c)
	--Reveal cards
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.rvtg)
	e1:SetOperation(s.rvop)
	c:RegisterEffect(e1)
	--lp4000
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.lptg)
	e2:SetOperation(s.lpop)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function s.rvtg(e,tp,ev,ep,ev,re,r,rp,chk)
	if chk==0 then
		local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
		if gdd:GetCount()<1 then return false end
		local gd=gdd:Filter(Card.IsFacedown,c)
		return gd:GetCount()>0
	end
end
function s.rvop(e,tp,eg,ep,ev,re,r,rp)
	local gdd=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
	if gdd:GetCount()<1 then return end
	local gd=gdd:Filter(Card.IsFacedown,c)
	if #gd>0 then Duel.ConfirmCards(tp, gd) end
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<4000 end
	Duel.SetTargetPlayer(tp)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.SetLP(p,4000)
end
