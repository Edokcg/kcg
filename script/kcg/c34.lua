--時械神 ラツィオン
local s, id = GetID()
function s.initial_effect(c)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000009,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(s.ntcon)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCondition(s.damcon)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_DRAW)
	e6:SetCondition(s.recon)
	e6:SetOperation(s.recop)
	c:RegisterEffect(e6)
	--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetProperty(EFFECT_FLAG_REPEAT)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.condition)
	e7:SetTarget(s.target)
	e7:SetOperation(s.activate)
	c:RegisterEffect(e7)
	--to deck
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(100000009,1))
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(s.tdcon)
	e8:SetTarget(s.tdtg)
	e8:SetOperation(s.tdop)
	c:RegisterEffect(e8)
	--sum limit
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetRange(LOCATION_MZONE)
	e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e13:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e13:SetTargetRange(1,0)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e14)
	local e15=e14:Clone()
	e15:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e15)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.damcon(e)
	return e:GetHandler():IsAttackPos()
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
function s.filter(c)
	return c:IsAbleToDeck() 
end
function s.condition(e)
	return e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_SZONE,1,c) end
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_SZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_SZONE,e:GetHandler())
	Duel.SendtoDeck(sg,nil,sg:GetCount(),REASON_EFFECT)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end