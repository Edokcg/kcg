--E－HERO マリシャス·デビル
local s, id = GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,58554959,aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER))

	--lizard check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(CARD_CLOCK_LIZARD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.lizcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)

	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.EvilHeroLimit)
	c:RegisterEffect(e2)

	--Pos Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.poscon)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	
	--must attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(s.atkcon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e5:SetValue(s.atklimit)
	c:RegisterEffect(e5)
end
s.material_setcode={0x8,0x6008}
s.dark_calling=true
s.listed_names={CARD_DARK_FUSION,58554959}

function s.lizcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),EFFECT_SUPREME_CASTLE)
end
function s.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function s.atklimit(e,c)
	return c==e:GetHandler()
end

function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION+0x10)~=0
end
function s.ffilter(c)
	return c:IsRace(RACE_FIEND) and c:GetLevel()>=6
end
function s.poscon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=e:GetHandler():GetControler() and ph>=0x8 and ph<=0x20
end
