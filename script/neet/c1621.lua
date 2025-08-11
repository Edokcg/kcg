--伊势(neet)
local m=1621
local cm=_G["c"..m]
function cm.initial_effect(c)
	Spirit.AddProcedure(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--Cannot be Special Summoned
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--flip and negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.discon)
	e2:SetCost(cm.discost)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)  
	--filp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FLIP)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.flipop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.tgcon)
	e3:SetTarget(cm.tgtg)
	e3:SetValue(cm.tgval)
	c:RegisterEffect(e3)
end   
cm.listed_card_types={TYPE_SPIRIT}
function cm.disfilter(c)
	return not c:IsType(TYPE_SPIRIT) and not c:IsSpellTrap()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_GRAVE,0,1,nil) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep==1-tp
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(1621,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.tgcon(e)
   return e:GetHandler():GetFlagEffect(1621)~=0
end
function cm.tgtg(e,c)
	return not c:IsType(TYPE_SPIRIT)
end
function cm.tgval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end