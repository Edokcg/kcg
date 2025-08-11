--No.62 銀河眼の光子竜皇
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),8,3,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

    local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.descon)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)

	-- Level/Rank
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_LEVEL_RANK)
	e1:SetTarget(function (e,c) return not c:IsType(TYPE_XYZ) end)
	c:RegisterEffect(e1)
	  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16719802,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.rankop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e3:SetCost(Cost.DetachFromSelf(1))
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3,false,EFFECT_MARKER_DETACH_XMAT)

	--Unaffected by opponent's monster effects
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.econ)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
	--Increase ATK
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(s.atkval)
	c:RegisterEffect(e5)
end
s.xyz_number=62
s.listed_series = {0x48}
s.listed_names={31801517}

function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,31801517)
end

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end
 
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLP(c:GetControler())>1000
end

function s.rankop(e,tp,eg,ep,ev,re,r,rp)
	   local c=e:GetHandler()
	   local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	   local tc=g:GetFirst()
	   while tc do
	   if tc:GetRank()<13 then
	   local e4=Effect.CreateEffect(c)
	   e4:SetType(EFFECT_TYPE_SINGLE)
	   e4:SetCode(EFFECT_UPDATE_RANK)
	   e4:SetReset(RESET_EVENT+0x1fe0000)
	   e4:SetValue(1)
	   tc:RegisterEffect(e4) end
	   if tc:GetLevel()<12 then	   
	   local e5=Effect.CreateEffect(c)
	   e5:SetType(EFFECT_TYPE_SINGLE)
	   e5:SetCode(EFFECT_UPDATE_LEVEL)
	   e5:SetReset(RESET_EVENT+0x1fe0000)
	   e5:SetValue(1)
	   tc:RegisterEffect(e5) end
	   tc=g:GetNext() end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	--Can make up to 3 attacks on monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetValue(2)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE)
	c:RegisterEffect(e1)
end

function s.econ(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,31801517)
end
function s.efilter(e,te)
	return te:IsMonsterEffect() and te:GetOwnerPlayer()==1-e:GetHandlerPlayer()
end

function s.atkval(e,c)
	local g=c:GetOverlayGroup()
	local sum=g:GetSum(Card.GetRank)
	return sum*200
end