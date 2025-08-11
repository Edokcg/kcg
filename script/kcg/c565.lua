--奧雷卡爾克斯艾恩伯特 (KA)
local s,id=GetID()
function s.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(37742478,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.atcon)
	e1:SetCost(s.atcost)
	e1:SetOperation(s.atop)
	c:RegisterEffect(e1)   
	
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.tfilter)
	e2:SetValue(500)
	c:RegisterEffect(e2) 
end

function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a==nil or d==nil or a:IsFacedown() or d:IsFacedown() then return false end
	return (d~=nil and a:GetControler()==tp and a:IsSetCard(0x900) and a:IsRelateToBattle())
		or (d~=nil and d:GetControler()==tp and d:IsFaceup() and d:IsSetCard(0x900) and d:IsRelateToBattle())
end

function s.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function s.atop(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a==nil or d==nil or a:IsFacedown() or d:IsFacedown() then return false end
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	if a:GetControler()==tp and a:IsSetCard(0x900) then local x=d d=a a=x end
	local aatk=a:GetAttack()
	local adef=a:GetDefense()
	local datk=d:GetAttack()
	local ddef=d:GetDefense()
	if aatk<0 then aatk=0 end
	if datk<0 then datk=0 end
	if adef<0 then adef=0 end
	if ddef<0 then ddef=0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(aatk)
	d:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetOwnerPlayer(tp)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	e2:SetValue(adef)
	d:RegisterEffect(e2)
end

function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x900)
end

function s.tfilter(e,c)
	return c:IsSetCard(0x900)
end