--被封印的右手 (K)
function c145.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
      e1:SetRange(LOCATION_MZONE)
      e1:SetCondition(c145.condition)
	e1:SetOperation(c145.operation)
	c:RegisterEffect(e1)
end

function c145.condition(e,tp,eg,ep,ev,re,r,rp)
      if Duel.GetAttacker()~=nil or Duel.GetAttackTarget()~=nil then
      return e:GetHandler()==Duel.GetAttacker() or e:GetHandler()==Duel.GetAttackTarget() end
end
function c145.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
