--殉道者之水精灵(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.con)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(1040)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.condtion)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.activate2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(1040)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.condtion2)
	e4:SetTarget(s.target3)
	e4:SetOperation(s.activate3)
	c:RegisterEffect(e4)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(s.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e12:SetTarget(s.distg9)
	c:RegisterEffect(e12)
end
function s.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function s.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end  
function s.condtion2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_MZONE,nil,id+1)
	return g:GetCount()<4 and Duel.GetLocationCount(1-e:GetHandlerPlayer(),LOCATION_MZONE)<=0
end
function s.defliter(c)
	return not c:IsCode(id+1)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.defliter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.activate3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(1-tp,s.defliter,1-tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function s.condtion(e,tp,eg,ep,ev,re,r,rp)
	local g =Duel.GetMatchingGroup(Card.IsCode,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil,id+1)
	return g:GetCount()>=4
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil,id+1)
	return rp==1-tp and g:GetCount()<4
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0xa60,TYPES_TOKEN,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- TYPES_TOKEN_MONSTER
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0xa60,TYPES_TOKEN,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,id+1)
	if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_ATTACK)
			token:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_LEAVE_FIELD)
			--e:SetLabel(tp)
			e3:SetOperation(s.damop)
			token:RegisterEffect(e3,true)
end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		--1-e:GetLabel()
		Duel.Damage(e:GetHandlerPlayer(),1500,REASON_EFFECT)
	end
	e:Reset()
end