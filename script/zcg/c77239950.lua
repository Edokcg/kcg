--黑魔導女孩大聚会(ZCG)
function c77239950.initial_effect(c)
    if aux.IsKCGScript then
        Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),7,2)
    else
        aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),7,2)
    end
    c:EnableReviveLimit()

    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239950,0))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c77239950.descost)   
    e1:SetTarget(c77239950.destg)
    e1:SetOperation(c77239950.desop)
    c:RegisterEffect(e1)

    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c77239950.val)
    c:RegisterEffect(e2)

    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239950,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239950.cost)
    e3:SetTarget(c77239950.tg)
    e3:SetOperation(c77239950.op)   
    c:RegisterEffect(e3)    
end
------------------------------------------------------------------------------------------------
function c77239950.sgfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove()
end
function c77239950.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and  Duel.IsExistingMatchingCard(c77239950.sgfilter,tp,LOCATION_GRAVE,0,1,nil) end
    local ct1=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
    local rg=Duel.SelectMatchingCard(tp,c77239950.sgfilter,tp,LOCATION_GRAVE,0,1,ct1,nil)
    Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
    e:SetLabel(rg:GetCount())
end
function c77239950.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
    local tc=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,tc,tc,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,tc,0,0)
end
function c77239950.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(sg,REASON_EFFECT)
end
------------------------------------------------------------------------------------------------
function c77239950.val(e,c)
    return Duel.GetMatchingGroupCount(c77239950.filter2,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end
function c77239950.filter2(c)
    return c:IsRace(RACE_SPELLCASTER)
end
------------------------------------------------------------------------------------------------
function c77239950.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c77239950.filter3(c)
    return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c77239950.tg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c77239950.filter3,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c77239950.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c77239950.filter3,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
       Duel.SSet(tp,g:GetFirst())
    end
end
