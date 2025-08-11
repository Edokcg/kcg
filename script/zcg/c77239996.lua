--幻想の魔術師
function c77239996.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77239996.spcon)
	e1:SetOperation(c77239996.spop)
	c:RegisterEffect(e1)
	--Eraser
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239996,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c77239996.erastg)
	e2:SetOperation(c77239996.erasop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c77239996.efilter)
	c:RegisterEffect(e6)
	--at limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetValue(c77239996.atlimit)
	c:RegisterEffect(e7)
end
function c77239996.filter(c)
	return c:IsFaceup() and c:IsCode(77239995)
end
function c77239996.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239996.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)  and Duel.CheckLPCost(c:GetControler(),500)
end
function c77239996.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,500)
end
function c77239996.erastg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c77239996.erasop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c77239996.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c77239996.atlimit(e,c)
	return c:IsCode(77239995)
end
