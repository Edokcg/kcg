--No.105 BK 流星のセスタス
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,3)
	c:EnableReviveLimit()

	  --cannot destroyed
        local e0=Effect.CreateEffect(c)
	  e0:SetType(EFFECT_TYPE_SINGLE)
	  e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	  e0:SetValue(s.indes)
	  c:RegisterEffect(e0)

	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(59627393,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCondition(s.condition)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.xyz_number=105
s.listed_series = {0x48}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
      and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local bc1,bc2=Duel.GetBattleMonster(tp)
	return bc1 and bc2 and bc1:IsSetCard(SET_BATTLIN_BOXER) and bc1:IsFaceup()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local bc1,bc2=Duel.GetBattleMonster(tp)
	if bc2:IsRelateToBattle() and bc2:IsNegatableMonster() then
		--Negate the effects of that opponent's monster while it is face-up until the end of this turn
		bc2:NegateEffects(c,RESET_PHASE|PHASE_END)
	end
	if bc1:IsRelateToBattle() then
		--That monster you control cannot be destroyed by that battle
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3000)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE|PHASE_DAMAGE)
		bc1:RegisterEffect(e1,true)
		--Also your opponent takes any battle damage you would have taken from that battle
		local e2=e1:Clone()
		e2:SetDescription(3112)
		e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
		bc1:RegisterEffect(e2,true)
	end
	--Battle cannot be negated
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNSTOPPABLE_ATTACK)
	e2:SetReset(RESET_PHASE|PHASE_DAMAGE)
	Duel.GetAttacker():RegisterEffect(e2)
end
