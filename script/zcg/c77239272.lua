--奥利哈刚 多兰之盾(ZCG)
function c77239272.initial_effect(c)
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCondition(c77239272.negcon)
    e3:SetTarget(c77239272.negtg)
    e3:SetOperation(c77239272.negop)
    c:RegisterEffect(e3)
end
--------------------------------------------------------------
function c77239272.nefilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xa50) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c77239272.negcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler()
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    if rp==ec:GetControler() then return end		
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c77239272.nefilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c77239272.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77239272.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT,LOCATION_REMOVED)
		local rg=Group.CreateGroup()
        local tc=eg:GetFirst()
        while tc do
            if tc:IsLocation(LOCATION_REMOVED) then
                local tpe=tc:GetType()
                if bit.band(tpe,TYPE_TOKEN)==0 then
                    local g1=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK,nil,tc:GetCode())
                    rg:Merge(g1)
                end
            end
            tc=eg:GetNext()
        end
        if rg:GetCount()>0 then
           Duel.BreakEffect()
           Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
        end
    end
end