--Number C88: Gimmick Puppet Disaster Leo
local s,id=GetID()
function s.initial_effect(c)
	--Rank Up Check
	aux.EnableCheckRankUp(c,nil,nil,48995978)
	c:EnableReviveLimit()

	--cannot special summon
	-- local e0=Effect.CreateEffect(c)
	-- e0:SetType(EFFECT_TYPE_SINGLE)
	-- e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- e0:SetValue(s.splimit)
	-- c:RegisterEffect(e0)

	--Cannot be destroyed by battle except with numbers
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(s.indes)
	c:RegisterEffect(e1)
	
	--Unaffected by other monster effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)

	--Inflict 4000 Damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(56910167,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(Cost.DetachFromSelf(1))
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)

	--Win during the end phase is Xyz material = 0
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.con)
	e5:SetOperation(s.op)
	
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_RANKUP_EFFECT)
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetLabelObject(e5)
	c:RegisterEffect(e7)
end
s.listed_names={48995978}
s.xyz_number=88

function s.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x95)
end

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(4000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,0,aux.Stringid(id,0))
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==tp and c:GetOverlayCount()==0 and c:GetFlagEffect(id)>0
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Win(c:GetControler(),WIN_REASON_DISASTER_LEO)
end
