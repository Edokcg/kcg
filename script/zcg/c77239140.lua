--青眼玉石龙(ZCG)
function c77239140.initial_effect(c)
	--recover1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetDescription(aux.Stringid(77239140,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77239140.reccost)
	e1:SetTarget(c77239140.rectg)
	e1:SetOperation(c77239140.recop)
	c:RegisterEffect(e1)
	--recover2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(77239140,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c77239140.condition)
	e2:SetTarget(c77239140.rectg1)
	e2:SetOperation(c77239140.recop1)
	c:RegisterEffect(e2)
end
function c77239140.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77239140.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetHandler():GetLevel()*600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetHandler():GetLevel()*600)
end
function c77239140.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c77239140.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_COST))
end
function c77239140.rectg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetHandler():GetAttack())
end
function c77239140.recop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
