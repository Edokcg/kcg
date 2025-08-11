--上古美杜莎(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
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
function s.indes(e,c)
	return not (c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER))
end
function s.tger(e,c)
	return c:IsSetCard(0xa120)
end
function s.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xa120) and te:IsActiveType(TYPE_MONSTER)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD,2)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.postg)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetOperation(s.posop)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e4,tp)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsPreviousPosition(POS_FACEDOWN)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(4869446,RESET_EVENT+RESETS_STANDARD,0,1,e:GetHandler():GetFieldID())
		tc=g:GetNext()
	end
end
function s.postg(e,c)
	for _,flag in ipairs({c:GetFlagEffectLabel(4869446)}) do
		if flag==e:GetHandler():GetFieldID() then return true end
	end
	return false
end