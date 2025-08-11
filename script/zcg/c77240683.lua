--不死之究极完全态大飞蛾(ZCG)
local s,id=GetID()
function s.initial_effect(c)
   --cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	  --summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(s.ttcon)
	e1:SetOperation(s.ttop)
	if aux.IsKCGScript then 
		e1:SetValue(SUMMON_TYPE_TRIBUTE)
	else
		e1:SetValue(SUMMON_TYPE_ADVANCE)
	end
	c:RegisterEffect(e1)
--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if #g>0 then
		local dam=g:GetSum(Card.GetAttack)
		if dam>0 then
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
function s.setcon(e,c,minc)
	if not c then return true end
	return false
end
function s.otfilter(c,tp)
	return c:IsRace(RACE_INSECT) and (c:IsControler(tp) or c:IsFaceup())
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return minc<=3 and Duel.CheckTribute(c,3,3,mg)
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(s.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local g=Duel.SelectTribute(tp,c,3,3,mg)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end