--奥利哈刚 铁甲战士(ZCG)
local s,id=GetID()
function s.initial_effect(c)
   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98710392,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetLabel(400)
	e1:SetCondition(s.atkcon)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
 --spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(98710392,1))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCondition(s.spcon)
	e7:SetTarget(s.sptg)
	e7:SetOperation(s.spop)
	c:RegisterEffect(e7)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(s.distg)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e5)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if tc and tc:IsType(TYPE_MONSTER) then
		tc:RegisterFlagEffect(98710392,RESET_EVENT+RESETS_STANDARD)
	end
end
function s.distg(e,c)
	return c:GetFlagEffect(98710392)~=0
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=math.floor(e:GetHandler():GetAttack()/700)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,ct,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,ct,tp,LOCATION_ONFIELD)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
   local ct=math.floor(e:GetHandler():GetAttack()/700)
   local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,ct,ct,nil) 
   if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsFaceup() and c:IsRelateToBattle()
		and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
end