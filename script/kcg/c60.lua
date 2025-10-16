--Ｎｏ.３９ 希望皇ホープ
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	  
	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)
	
	--disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84013237,0))
	e1:SetProperty(0+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCondition(s.atkcon)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
end
s.xyz_number=39
s.listed_series = {0x48}

 function s.indes(e,c)
	--return not c:IsSetCard(0x48)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end
function s.desfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and( not  c:IsSetCard(0x48) or c:IsSetCard(0x1048))
end
function s.descon2(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.desfilter2,c:GetControler(),0,LOCATION_MZONE,1,c) 
end
 function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) or Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) or Duel.CheckEvent(EVENT_BE_BATTLE_TARGET) or Duel.CheckEvent(EVENT_BATTLE_START) or Duel.CheckEvent(EVENT_BATTLE_CONFIRM))
	  and not c:IsStatus(STATUS_CHAINING) 
	  and Duel.GetAttacker()~=nil and Duel.GetAttacker():CanAttack() and not Duel.GetAttacker():IsStatus(STATUS_ATTACK_CANCELED) 
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end