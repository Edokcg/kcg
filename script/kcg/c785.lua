--Go-DD World (K)
local s, id = GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)   

	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	-- e2:SetTarget(s.adcon)
	e2:SetValue(0x20af)
	c:RegisterEffect(e2)
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
   return Duel.IsExistingMatchingCard(s.usefilter,tp,LOCATION_ONFIELD,0,5,nil) 
end
function s.usefilter(c)
   return c:IsFaceup() and c:IsSetCard(0xaf)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
end

function s.adcon(e,c)
	return c:IsSetCard(0xaf) and not c:IsSetCard(0x20af)
 end