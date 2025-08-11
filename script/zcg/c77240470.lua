--奥利哈刚第五层结界守护阵(ZCG)
local s,id=GetID()
function s.initial_effect(c)
			   --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(s.moop)
	c:RegisterEffect(e1)
		--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(s.motg)
	e2:SetOperation(s.moop2)
	c:RegisterEffect(e2)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.sdcon2)
	e4:SetOperation(s.sdop)
	c:RegisterEffect(e4)
	--Activate
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,3))
	e9:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_ONFIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCountLimit(1)
	e9:SetCost(s.descost)
	e9:SetTarget(s.target2)
	e9:SetOperation(s.activate2)
	c:RegisterEffect(e9)
	--immune spell
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_ONFIELD)
	e11:SetCondition(s.imcon)
	e11:SetValue(s.efilter9)
	c:RegisterEffect(e11)
end
function s.desfilter(c)
return c:IsReleasable()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
	local dam=g:GetFirst():GetAttack()
	e:SetLabel(dam)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
   local dam=e:GetLabel()
   Duel.Recover(tp,dam,REASON_EFFECT)
   Duel.Damage(1-tp,dam,REASON_EFFECT)
end

function s.cfilter9(c)
	return c:IsFaceup() and c:IsSetCard(0xa50) 
end
function s.imcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter9,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function s.efilter9(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98710445)==0
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp) 
	e:GetHandler():CopyEffect(98710443,RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterFlagEffect(98710445,RESET_EVENT+0x1fe0000,0,1)
end
function s.motg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_SZONE,0)>0 and Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)~=nil) or (Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_SZONE,0)>1 and Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)==nil) end
end
function s.moop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
function s.moop2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if (Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_SZONE,0)>0 and Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)~=nil) or (Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_SZONE,0)>1 and Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)==nil) then
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
end
function s.filter(c)
	return c:IsCode(77239264) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
