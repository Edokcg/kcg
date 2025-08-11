--原始昆虫 狂野蜈蚣兽(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--synchro summon
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(Card.IsRace,RACE_INSECT),1,1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(s.atktarget)
	c:RegisterEffect(e2)
		--
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(s.efilter)
	c:RegisterEffect(e11)
end
function s.atktarget(e,c)
	return c:GetAttack()>=3000
end
function s.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te) and ec:GetControler()~=c:GetControler()
end