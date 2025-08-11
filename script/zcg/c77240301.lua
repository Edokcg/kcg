--装甲 铁斧将军 （ZCG）
function c77240301.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,77240300,1,c77240301.ffilter,1)
	Fusion.AddContactProc(c,c77240301.contactfil,c77240301.contactop,c77240301.splimit,nil,nil,nil,false)
	  --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240301,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c77240301.destg)
	e1:SetOperation(c77240301.desop)
	c:RegisterEffect(e1)
	  --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240301,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c77240301.tgcost)
	e2:SetTarget(c77240301.target)
	e2:SetOperation(c77240301.activate)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240301,2))
	e3:SetCategory(CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c77240301.rettg)
	e3:SetOperation(c77240301.retop)
	c:RegisterEffect(e3)
--negate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c77240301.negcon)
	e0:SetTarget(c77240301.negtg)
	e0:SetOperation(c77240301.negop)
	c:RegisterEffect(e0)
--negate attack
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_BE_BATTLE_TARGET)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(c77240301.condition9)
	e11:SetTarget(c77240301.target9)
	e11:SetOperation(c77240301.operation9)
	c:RegisterEffect(e11)
end

function c77240301.ffilter(c,fc,sub,sub2,mg,sg)
	return c:IsSetCard(0xa110)
end
function c77240301.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function c77240301.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
function c77240301.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c77240301.condition9(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsPosition(POS_FACEUP_DEFENSE) and tc:IsSetCard(0xa110)
end
function c77240301.target9(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if chk==0 then return a:IsOnField() and a:GetControler(1-tp) end
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
end
function c77240301.operation9(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local dam=tc:GetAttack()
	if tc:IsRelateToEffect(e) and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		 Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
function c77240301.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return rp==1-tp
end
function c77240301.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77240301.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
function c77240301.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c77240301.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
function c77240301.spfilter(c)
return c:IsSetCard(0xa110) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function c77240301.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c77240301.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(3,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c77240301.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	Duel.SendtoGrave(g2,REASON_COST)
end
function c77240301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if chk==0 then return rg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,rg:GetCount(),0,0)
end
function c77240301.activate(e,tp,eg,ep,ev,re,r,rp)
local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
 Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
function c77240301.cfilter(c)
	return (c:IsFusionCode(98710729) or c:IsFusionSetCard(0xa110) and c:IsType(TYPE_MONSTER)) and c:IsAbleToDeckOrExtraAsCost()
end
function c77240301.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xa110)>0 end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c77240301.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xa110)
	if sg<=0 then return end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,sg,nil)
	Duel.Destroy(g,REASON_EFFECT) 
end
