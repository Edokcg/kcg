--特莱恩之落穴(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(function(e) return e:GetHandler():IsReason(REASON_DRAW) end)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
s.listed_names={91812341}
s.listed_series={0x108a}
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function s.setfilter(c)
	return c:IsFaceup() and c:IsCode(91812341)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_MZONE,0,1,nil) and c:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		 Duel.BreakEffect()
		 Duel.SSet(tp,c)
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x108a)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsPreviousLocation(LOCATION_HAND)
		and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return s.cfilter(tc,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)==1 then   
		local atk=tc:GetBaseAttack()   
		local mg=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_MZONE,0,nil) 
		for ec in aux.Next(mg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			ec:RegisterEffect(e1,true)
		end
	end
end