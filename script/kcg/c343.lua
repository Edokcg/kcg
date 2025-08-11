--輪廻萌芽 (K)
local s,id=GetID()
local zexal=nil
function s.initial_effect(c)
	zexal=c
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79387932,1))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.con)
		ge1:SetOperation(s.op)
		Duel.RegisterEffect(ge1,0)
	end)
end

function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #g>0 end
	Duel.RegisterFlagEffect(tp,343,RESET_EVENT+0x1fe0000,0,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		Duel.SSet(tp,sg:GetFirst())
	end
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(e:GetOwner():GetControler(),EFFECT_CANNOT_SSET)
	and e:GetOwner():IsFaceup() and e:GetOwner():IsStatus(STATUS_CHAINING)
end
function s.splimit(e,c,tp)
	return (not target or target(e,c,tp)) and c~=zexal
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local effs={Duel.GetPlayerEffect(e:GetOwner():GetControler(),EFFECT_CANNOT_SSET)}
	for _,eff in ipairs(effs) do
		if eff:GetLabel()~=343 then
			target=eff:GetTarget()
			eff:SetTarget(s.splimit)
			eff:SetLabel(343)
		end
	end
end