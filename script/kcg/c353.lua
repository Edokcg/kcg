--反-天空 (K)
local s,id=GetID()
function s.initial_effect(c)
	local e3=Effect.CreateEffect(c) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_OVERLAY)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)    
end

function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=eg:GetFirst()
	Duel.Hint(HINT_CARD,ep,353)
	if not eqc then return end
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5975022,0))  
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(s.atkcon2)
	e3:SetCost(s.atkcost2)
	e3:SetTarget(s.atktg2)
	e3:SetOperation(s.atkop2)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	eqc:RegisterEffect(e3)
end

function s.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(1-tp) and a:IsOnField() and a:IsFaceup() 
end
function s.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetOwner()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if a and a:IsFaceup() then
	Duel.Destroy(a,REASON_EFFECT) end
end
