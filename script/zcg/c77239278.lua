--哈刚封印
function c77239278.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_BECOME_TARGET)
    e1:SetCondition(c77239278.negcon)
    e1:SetCost(c77239278.cost)
    e1:SetTarget(c77239278.negtg)
    e1:SetOperation(c77239278.negop)
    c:RegisterEffect(e1)

	--[[
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)	
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c77239278.drcon)
    e2:SetTarget(c77239278.target)
    e2:SetOperation(c77239278.activate)
    c:RegisterEffect(e2)]]
	
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c77239278.spcon)
	e2:SetTarget(c77239278.sptg)
	e2:SetOperation(c77239278.spop)
	c:RegisterEffect(e2)
end
-------------------------------------------------------------------
function c77239278.costfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa50) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost()
end
function c77239278.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239278.costfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239278.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c77239278.tgfilter(c,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0xa50)
end
function c77239278.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c77239278.tgfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c77239278.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77239278.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(re:GetHandler(),REASON_EFFECT)
    end
end

--[[function c77239278.drcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_DESTROY)~=0 and rp~=tp and c:GetPreviousControler()==tp
        and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c77239278.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239278.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_RULE)
    end
end]]

function c77239278.spcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_DESTROY~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c77239278.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239278.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_RULE)
    end
end