--鹰身与幻之狮鹫
function c1631.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCodeFun(c,76812113,c1631.matfilter,1,true,true)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1631,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1631.rmcon)
	e1:SetTarget(c1631.rmtg)
	e1:SetOperation(c1631.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c1631.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c1631.imcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--indestructable
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	--atk/def down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(c1631.value)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(14504044,1))
	e7:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c1631.negcon)
	e7:SetCost(c1631.negcost)
	e7:SetTarget(c1631.negtg)
	e7:SetOperation(c1631.negop)
	c:RegisterEffect(e7)
end
function c1631.matfilter(c)
	return c:IsFusionSetCard(0x64) or c:IsFusionCode(74852097)
end
function c1631.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end
function c1631.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsFusionType,1,nil,TYPE_NORMAL) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c1631.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c1631.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1631.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local rg=Duel.GetMatchingGroup(c1631.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rg,rg:GetCount(),0,0)
end
function c1631.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(c1631.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function c1631.imcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,76812113)
end
function c1631.valfilter(c)
	return c:IsCode(76812113) and c:IsFaceup()
end
function c1631.value(e,c)
	local ct=Duel.GetMatchingGroupCount(c1631.valfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	return ct*(-100)
end
function c1631.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c1631.costfilter(c)
	return c:IsCode(76812113) and c:IsAbleToRemoveAsCost()
end
function c1631.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1631.costfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1631.costfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1631.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c1631.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end






