--奥利哈刚 阿喀琉斯 （ZCG）
function c77240221.initial_effect(c)
 --atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77240221,1))
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c77240221.sdcon)
	e5:SetCost(c77240221.spcost)
	e5:SetTarget(c77240221.rectg)
	e5:SetOperation(c77240221.recop)
	c:RegisterEffect(e5)
	 --indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	e2:SetCondition(c77240221.indcon)
	c:RegisterEffect(e2)
end
function c77240221.indcon(e)
	return e:GetHandler():IsAttackPos()
end
function c77240221.sdcon(e,tp,eg,ep,ev,re,r,rp)
   return Duel.GetBattleDamage(tp)>=3000
end
function c77240221.costfilter(c)
	return c:IsSetCard(0xa50) and c:IsAbleToGraveAsCost()
end
function c77240221.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77240221.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	local rg=Duel.GetMatchingGroup(c77240221.costfilter,tp,LOCATION_MZONE,0,nil)
	local dam=rg:GetSum(Card.GetAttack)+rg:GetSum(Card.GetDefense)
	e:SetLabel(dam)
	Duel.SendtoGrave(rg,REASON_COST)
end
function c77240221.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,dam)
	Duel.SetChainLimit(aux.FALSE)
end
function c77240221.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end


