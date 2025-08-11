--CNo.2 混沌源數之門-負貳 (KA)
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,2,4,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()

	--cannot destroyed
	  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--selfdes
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_SINGLE)
	-- e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetCode(EFFECT_SELF_DESTROY)
	-- e2:SetCondition(s.descon)
	-- c:RegisterEffect(e2)

	--Banish and Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	  e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(s.rmcon)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end 
s.xyz_number=2
s.listed_series = {0x48}
s.listed_names={41418852,42230449}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(42230449) and Duel.IsExistingMatchingCard(s.damfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

-- function s.descon(e)
-- 	local c=e:GetHandler()
-- 	return not Duel.IsExistingMatchingCard(s.damfilter,e:GetHandlerPlayer(),LOCATION_SZONE,LOCATION_SZONE,1,nil)
-- end

function s.damfilter(c)
	return c:IsFaceup() and c:IsCode(41418852)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if g~=nil and s.damfilter(g) then
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	g:RegisterEffect(e4)
	end
end
