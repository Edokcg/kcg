--Number 4: Gate of Numeron - Catvari
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,1,3)
	c:EnableReviveLimit()

	  --cannot destroyed
		local e0=Effect.CreateEffect(c)
	  e0:SetType(EFFECT_TYPE_SINGLE)
	  e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	  e0:SetValue(s.indes)
	  c:RegisterEffect(e0)

	-- with out Numeron Network
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72167543,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	  e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3,false,EFFECT_MARKER_DETACH_XMAT)
end
s.xyz_number=4
s.listed_series = {0x48}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end
function s.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (not c:IsSetCard(0x48) or c:IsSetCard(0x1048))
end
function s.descon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.desfilter,c:GetControler(),0,LOCATION_MZONE,1,c)
end

function s.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x14b)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
