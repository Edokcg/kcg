--上古魔纹黑法师 特拉斯(ZCG)
local s,id=GetID()
function s.initial_effect(c)
--
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(s.ttcon)
	e1:SetOperation(s.ttop)
	e1:SetValue(SUMMON_TYPE_TRIBUTE)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
											   --immue 
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(EFFECT_IMMUNE_EFFECT)
	e17:SetRange(LOCATION_MZONE)
	e17:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e17:SetTarget(s.tger)
	e17:SetValue(s.efilter)
	c:RegisterEffect(e17)
	local e18=e17:Clone()
	e18:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e18:SetValue(s.indes)
	c:RegisterEffect(e18)
end
function s.desfilter(c)
	return c:IsFacedown()
end 
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		local dam=Duel.Destroy(g,REASON_EFFECT)
		Duel.Damage(tp,dam*500,REASON_EFFECT)
	end
end
function s.otfilter(c, tp)
	return c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER)
end

function s.ttcon(e, c, minc)
	if c == nil then
		return true
	end
	local tp = c:GetControler()
	local mg = Duel.GetMatchingGroup(s.otfilter, tp, LOCATION_MZONE, 0, nil, tp)
	return minc <= 1 and Duel.CheckTribute(c, 2, 2, mg)
end

function s.ttop(e, tp, eg, ep, ev, re, r, rp, c)
	local mg = Duel.GetMatchingGroup(s.otfilter, tp, LOCATION_MZONE, 0, nil, tp)
	local sg = Duel.SelectTribute(tp, c, 2, 2, mg)
	c:SetMaterial(sg)
	Duel.Release(sg, REASON_SUMMON + REASON_MATERIAL)
end
function s.indes(e,c)
	return not (c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER))
end
function s.tger(e,c)
	return c:IsSetCard(0xa120)
end
function s.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xa120) and te:IsActiveType(TYPE_MONSTER)
end