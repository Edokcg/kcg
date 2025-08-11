--无形噬体·罪恶(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,s.matfilter,3)
	--Link Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(1,0)
	e1:SetOperation(aux.TRUE)
	e1:SetValue(s.extraval)
	c:RegisterEffect(e1)
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD)
	e2a:SetCode(EFFECT_ADD_TYPE)
	e2a:SetRange(LOCATION_EXTRA)
	e2a:SetTargetRange(LOCATION_PZONE,0)
	e2a:SetCondition(s.addtypecon)
	e2a:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe0))
	e2a:SetValue(TYPE_MONSTER)
	c:RegisterEffect(e2a)   
	--negate opponent
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetCondition(function(e) return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,2,nil,0xe0) end)
	c:RegisterEffect(e4)
	--atkchange
	local e3=e4:Clone(c)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e2=e4:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e2)
	--negate Amorphage p Monter
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_DISABLE)
	e10:SetTargetRange(LOCATION_MZONE,0)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(function(e) return Duel.GetTurnPlayer()==e:GetHandlerPlayer() end)
	e10:SetTarget(s.disable)
	c:RegisterEffect(e10)
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_RELEASE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.regcon)
	e6:SetOperation(s.regop)
	c:RegisterEffect(e6)
end
s.listed_series={0xe0}
s.listed_names={1758}
function s.matfilter(c)
	return (c:IsAttack(0) or c:IsDefense(0)) and c:IsRace(RACE_DRAGON)
end
function s.matfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xe0) and c:IsType(TYPE_PENDULUM)
end
function s.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or not (sc and sc:IsCode(id)) then
			return Group.CreateGroup()
		else
			Duel.RegisterFlagEffect(tp,id,0,0,1)
			return Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_PZONE,0,nil)
		end
	elseif chk==2 then
		Duel.ResetFlagEffect(e:GetHandlerPlayer(),id)
	end
end
function s.addtypecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0
end
function s.disable(e,c)
	return c:IsSetCard(0xe0) and c:IsType(TYPE_PENDULUM)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1758,0,TYPES_TOKEN,0,0,1,RACE_DRAGON,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,1758)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,1758)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsCode,nil,1758)
	Duel.Draw(tp,ct,REASON_EFFECT)
end