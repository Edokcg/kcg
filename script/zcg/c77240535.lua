--欧贝利斯克之远征军(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
--cannot trigger
	local e101=Effect.CreateEffect(c)
	e101:SetType(EFFECT_TYPE_FIELD)
	e101:SetCode(EFFECT_CANNOT_TRIGGER)
	e101:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e101:SetRange(LOCATION_MZONE)
	e101:SetTargetRange(0,0xa)
	e101:SetTarget(s.distg99)
	c:RegisterEffect(e101)
	--disable
	local e102=Effect.CreateEffect(c)
	e102:SetType(EFFECT_TYPE_FIELD)
	e102:SetCode(EFFECT_DISABLE)
	e102:SetRange(LOCATION_MZONE)
	e102:SetTargetRange(0,LOCATION_ONFIELD)
	e102:SetTarget(s.distg99)
	c:RegisterEffect(e102)
	--disable effect
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e103:SetCode(EVENT_CHAIN_SOLVING)
	e103:SetRange(LOCATION_MZONE)
	e103:SetOperation(s.disop99)
	c:RegisterEffect(e103)
	--
	local e104=Effect.CreateEffect(c)
	e104:SetType(EFFECT_TYPE_FIELD)
	e104:SetCode(EFFECT_SELF_DESTROY)
	e104:SetRange(LOCATION_MZONE)
	e104:SetTargetRange(0,LOCATION_ONFIELD)
	e104:SetTarget(s.distg99)
	c:RegisterEffect(e104)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	e2:SetTarget(s.srtg)
	e2:SetOperation(s.srop)
	c:RegisterEffect(e2)
end
function s.filter(c,atk)
	return c:IsAttackBelow(atk)
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil,atk) end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
		local atk=e:GetHandler():GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,atk)
		Duel.Destroy(g,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:GetLevel()>0 then
			local num=tc:GetLevel()*1000
			Duel.Recover(tp,num,REASON_EFFECT)
	end
end
function s.distg99(e,c)
	return c:IsSetCard(0xa90) or c:IsSetCard(0xa110)
end
function s.disop99(e,tp,eg,ep,ev,re,r,rp)
	if  (re:GetHandler():IsSetCard(0xa90) or re:GetHandler():IsSetCard(0xa110)) and re:GetHandler():IsControler(1-tp) then
		Duel.NegateEffect(ev)
	end
end