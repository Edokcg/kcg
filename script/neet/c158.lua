local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),3)

    --immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetCondition(s.econ)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)

	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)

	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(s.atcon)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
end

function s.econ(e)
	return Duel.GetFieldGroupCount(e:GetOwner():GetControler(), LOCATION_MZONE, 0)==Duel.GetMatchingGroupCount(Card.IsType, e:GetOwner():GetControler(), LOCATION_MZONE, 0, nil, TYPE_LINK) and Duel.GetFieldGroupCount(e:GetOwner():GetControler(), LOCATION_MZONE, 0) > 0
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function s.atkval(e,c)
    local g=c:GetLinkedGroup()
    if #g<1 then return 0 end
    local sg=g:Filter(Card.IsType, nil, TYPE_LINK)
    if #sg<1 then return 0 end
	return sg:GetSum(Card.GetLink)*300
end

function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():CanChainAttack()
    and e:GetHandler()==Duel.GetAttacker()
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(3208)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	e:GetHandler():RegisterEffect(e1)
end