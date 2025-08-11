--卡通恶魔 绿(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	c:RegisterEffect(e2)
 --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.sdescon)
	e3:SetOperation(s.sdesop)
	c:RegisterEffect(e3)
	--avoid atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetCondition(s.atcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_FZONE,0)
	e4:SetTarget(s.efilter)
	e4:SetValue(1)
	c:RegisterEffect(e4)
--inactivatable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_INACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(s.effectfilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_DISEFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(s.effectfilter)
	c:RegisterEffect(e6)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,1)
	e8:SetValue(s.aclimit)
	c:RegisterEffect(e8)
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD)
end
function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and (te:GetHandler():IsCode(15259703)  or  te:GetHandler():IsCode(900000079)  or te:GetHandler():IsCode(511001251)) and bit.band(loc,LOCATION_ONFIELD)~=0
end
function s.efilter(e,c)
	return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function s.cfilter2(c,code)
	return c:IsFaceup() and c:IsSetCard(0x62) and not c:IsCode(code)
end
function s.atcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter2,e:GetOwnerPlayer(),LOCATION_MZONE,0,1,nil,e:GetHandler():GetCode())
end
function s.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and (c:GetPreviousCodeOnField()==15259703 or c:GetPreviousCodeOnField()==900000079 or c:GetPreviousCodeOnField()==511001251  ) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.sfilter,1,nil)
end
function s.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.cfilter(c)
	return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end