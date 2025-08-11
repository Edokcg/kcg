--地缚神 红莲之恶魔
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,10000000)
	
	--没有场地魔法时效果无效化
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetCondition(s.sdcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e2)
	
	--没有场地魔法时结束阶段破坏
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(900000041,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_REPEAT+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.sdcon)
	e3:SetTarget(s.sdtg)
	e3:SetOperation(s.sdop)
	c:RegisterEffect(e3)
	
	--不能成为被攻击对象
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
	
	--可以直接攻击
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e5)
	
	--不受对方魔法陷阱效果
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	--e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(s.efilter)
	c:RegisterEffect(e6)
	
	--墓地地缚神数量提升攻击
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(s.atkval)
	c:RegisterEffect(e7)
	
	--无效对方怪兽攻击
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(900000041,2))
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCode(EVENT_ATTACK_ANNOUNCE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(s.nacon)
	e8:SetTarget(s.natg)
	e8:SetOperation(s.naop)
	c:RegisterEffect(e8)
	
	--除外结束阶段返回场上
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(900000041,2))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetRange(LOCATION_REMOVED)
	e9:SetCountLimit(1)
	e9:SetCondition(s.spcon)
	e9:SetTarget(s.sptg)
	e9:SetOperation(s.spop)
	c:RegisterEffect(e9)
end
s.listed_series={0x21}
------------------------------------------------------------------------------------------------------------
function s.sdcon(e)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return ((f1==nil or not f1:IsFaceup()) and (f2==nil or not f2:IsFaceup()))
end

function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.dfilter(c)
	return c:IsSetCard(0x21)
end

function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.dfilter,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_TUNER)*1000
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.nacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end

function s.natg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc==Duel.GetAttacker() end
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.GetAttacker():IsCanBeEffectTarget(e)
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetTargetCard(Duel.GetAttacker())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end

function s.naop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateAttack()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
		c:RegisterFlagEffect(900000041,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(900000041)~=0
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
