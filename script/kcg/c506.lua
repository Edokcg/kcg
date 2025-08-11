--封印の黄金櫃
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetValue(CARD_SHINING_SARCOPHAGUS)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Cannot be destroyed by monster effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(function(_,re) return re:IsMonsterEffect() end)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_SHINING_SARCOPHAGUS}

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc==nil then return end
    if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)<1 then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_REMOVED)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
    e1:SetCondition(s.thcon)
    e1:SetOperation(s.thop)
    e1:SetLabel(0)
    tc:RegisterEffect(e1)
    local code=tc:GetCode()
    --Negate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetRange(LOCATION_SZONE)
    e1:SetLabel(code)
    e1:SetLabelObject(tc)
    e1:SetCondition(s.negcon)
    e1:SetCost(s.negcost)
    e1:SetTarget(s.negtg)
    e1:SetOperation(s.negop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
    --instant
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(93016201,0))
    e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_SPSUMMON)
    e2:SetLabel(code)
    e2:SetLabelObject(tc)
    e2:SetCondition(s.negcon2)
    e2:SetCost(s.negcost)
    e2:SetTarget(s.negtg2)
    e2:SetOperation(s.negop2)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SUMMON)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EVENT_FLIP_SUMMON)
    c:RegisterEffect(e4)
    tc:CreateEffectRelation(e1)
    tc:CreateEffectRelation(e2)
    tc:CreateEffectRelation(e3)
    tc:CreateEffectRelation(e4)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	else e:SetLabel(1) end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:GetHandler():IsCode(e:GetLabel()) 
		and Duel.IsChainNegatable(ev)
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc and tc:IsRelateToEffect(e) and tc:IsFacedown() end
	Duel.ConfirmCards(1-tp,tc)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.filter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function s.negcon2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and eg:IsExists(s.filter,1,nil,e:GetLabel())
end
function s.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(s.filter,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.negop2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filter,nil,e:GetLabel())
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end