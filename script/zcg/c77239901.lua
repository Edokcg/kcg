--光之创造神 赫尔阿克帝(ZCG)
function c77239901.initial_effect(c)
    c:EnableReviveLimit()
    --sendtohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239901,1))
	e1:SetCategory(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetOperation(c77239901.activate1)
    c:RegisterEffect(e1)

    --unaffectable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(c77239901.efilter)
    c:RegisterEffect(e2)

    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetDescription(aux.Stringid(77239901,0))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e3:SetTarget(c77239901.target)
    e3:SetOperation(c77239901.operation)
    c:RegisterEffect(e3)

    --除外
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239901,2))	
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE) 
    e4:SetTarget(c77239901.target4)
    e4:SetOperation(c77239901.activate4)
    c:RegisterEffect(e4)

    --recover
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239901,3))		
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCategory(CATEGORY_RECOVER)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE) 	
    e5:SetTarget(c77239901.tg)
    e5:SetOperation(c77239901.op)
    c:RegisterEffect(e5)	
end
------------------------------------------------------------------------

function c77239901.thfilter(c)
    return c:IsCode(77239910) and c:IsAbleToHand()
end
function c77239901.thfilter1(c)
    return c:IsCode(77239911) and c:IsAbleToHand()
end
function c77239901.thfilter2(c)
    return c:IsCode(77239912) and c:IsAbleToHand()
end
function c77239901.activate1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c77239901.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    local g1=Duel.SelectMatchingCard(tp,c77239901.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    local g2=Duel.SelectMatchingCard(tp,c77239901.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)	
    g:Merge(g1)
    g:Merge(g2)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c77239901.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
------------------------------------------------------------------------
function c77239901.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239901.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
------------------------------------------------------------------------
function c77239901.filter4(c)
    return c:IsAbleToRemove()
end
function c77239901.target4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c77239901.filter4,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77239901.activate4(e,tp,eg,ep,ev,re,r,rp)
    local rg=Duel.GetMatchingGroup(c77239901.filter4,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,nil)
    Duel.ConfirmCards(tp,rg)
    local tc=rg:Select(tp,1,1,nil)
    --Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)	
    Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
end
------------------------------------------------------------------------
function c77239901.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c77239901.op(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end

