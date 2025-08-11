--装甲 枪兵的坐骑 （ZCG）
function c77240283.initial_effect(c)
		--fusion material
	c:EnableReviveLimit()
	if aux.IsKCGScript then
        Fusion.AddProcMixN(c,true,true,77240280,2)
        Fusion.AddContactProc(c,c77240283.contactfil,c77240283.contactop,c77240283.splimit,nil,nil,nil,false)
    else
        aux.AddFusionProcCodeRep(c,77240280,2,true,true)
        aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
    end
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetOperation(c77240283.op)
	c:RegisterEffect(e1)
  --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98710695,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c77240283.descon)
	e2:SetTarget(c77240283.destg)
	e2:SetOperation(c77240283.desop)
	c:RegisterEffect(e2)
--negate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c77240283.negcon)
	e0:SetTarget(c77240283.negtg)
	e0:SetOperation(c77240283.negop)
	c:RegisterEffect(e0)
end

function c77240283.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function c77240283.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
function c77240283.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c77240283.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	Duel.RegisterEffect(e1,tp)
end
function c77240283.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return rp==1-tp
end
function c77240283.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77240283.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
function c77240283.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c77240283.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c77240283.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77240283.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,c) end
	local sg=Duel.GetMatchingGroup(c77240283.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240283.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77240283.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,e:GetHandler())
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
end
