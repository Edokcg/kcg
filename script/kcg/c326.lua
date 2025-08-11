--Number S39 - Utopia ONE
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),5,3,s.ovfilter,aux.Stringid(56832966,0))

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	--e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetCondition(s.atkcon)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)

	--negate
	local e5=Effect.CreateEffect(c)
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
s.xyz_number=39
s.listed_series = {0x48}

function s.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x107f) and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp) and c:GetRank()==4
end

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048)
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x7f)
end
function s.atkval(e,c)
	return e:GetHandler():GetRank()*1000
end

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