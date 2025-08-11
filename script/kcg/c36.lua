--SNo. 閃光超量體 
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
    
    -- battle indestructable
    local e3 = Effect.CreateEffect(c)
    -- e3:SetDescription(aux.Stringid(id,0),true)
    -- e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard, 0x48)))
    c:RegisterEffect(e3)

	--negate
	local e5=Effect.CreateEffect(c)
    -- e5:SetDescription(aux.Stringid(id,1),true)
    -- e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetOperation(s.negop1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetOperation(s.negop2)
	c:RegisterEffect(e6)
end
s.listed_series = {0x48}

function s.negop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d~=nil and d:IsFaceup() and d:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e2)
	end
end
function s.negop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if a~=nil and a:IsFaceup() and a:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		a:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		a:RegisterEffect(e2)
	end
end
