--青眼白龙·蓝眼琪莎拉(ZCG)
function c77239144.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c77239144.sumsuc)
	c:RegisterEffect(e3)
	--skip
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCode(EFFECT_SKIP_TURN)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_ONFIELD,0)
	e7:SetValue(c77239144.efilter)
	c:RegisterEffect(e7)
	
	--不会被战斗破坏
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	
	--[[at limit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_ONFIELD,0)
	e8:SetValue(c77239144.atlimit)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e9)
	local e10=e8:Clone()
	e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e10)]]
	--atk/def
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SET_BASE_ATTACK)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(99999999)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_SET_BASE_DEFENSE)
	e12:SetValue(99999999)
	c:RegisterEffect(e12)
end
function c77239144.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) then return end
	Duel.SetChainLimitTillChainEnd(c77239144.chainlm)
end
function c77239144.chainlm(e,rp,tp)
	return tp==rp
end
function c77239144.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--[[function c77239144.atlimit(e,c)
	return c:GetHandler():IsCode(2105)
end]]
