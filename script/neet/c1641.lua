--命运英雄 死亡恐惧人
function c1641.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCodeFun(c,40591390,aux.FilterBoolFunction(Card.IsSetCard,0x8),2,true,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c1641.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c1641.hspcon)
	e2:SetOperation(c1641.hspop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(c1641.val)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c1641.indtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1641,0))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c1641.damcon)
	e6:SetOperation(c1641.damop)
	c:RegisterEffect(e6)
	if not c1641.global_check then
		c1641.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c1641.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1641.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c1641.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsCode(40591390) and re and re:GetHandler():IsCode(75041269) and tc:IsFaceup() then
			tc:RegisterFlagEffect(1641,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		tc=eg:GetNext()
	end
end
function c1641.hspfilter(c,tp,sc)
	return c:IsCode(40591390) and c:IsFaceup() and c:GetFlagEffect(1641)>0
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c1641.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c1641.hspfilter,1,nil,c:GetControler(),c)
end
function c1641.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c1641.hspfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c1641.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc008)
end
function c1641.val(e,c)
	local g=Duel.GetMatchingGroup(c1641.vfilter,c:GetControler(),LOCATION_MZONE,0,c)
	return g:GetSum(Card.GetBaseAttack)
end
function c1641.indtg(e,c)
	return c:IsSetCard(0xc008) and c:IsFaceup()
end
function c1641.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and rp==1-tp 
		and c:IsReason(REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_MZONE)
end
function c1641.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,5)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,4)
	end
	e1:SetCountLimit(1)
	e1:SetCondition(c1641.damcon2)
	e1:SetOperation(c1641.damop2)
	Duel.RegisterEffect(e1,tp)
	c:SetTurnCounter(0)
end
function c1641.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1641.damop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==4 then
		Duel.Damage(1-tp,8000,REASON_EFFECT)
	end
end