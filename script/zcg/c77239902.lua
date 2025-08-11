--光之创造神 赫尔阿克帝(ZCG)
function c77239902.initial_effect(c)
    c:EnableReviveLimit()
    --sendtohand
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetOperation(c77239902.activate1)
    c:RegisterEffect(e1)

    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCondition(c77239902.condition)
    e2:SetTarget(c77239902.damtg)
    e2:SetOperation(c77239902.damop)
    c:RegisterEffect(e2)
	
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239902,0))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetTarget(c77239902.destg)
    e3:SetOperation(c77239902.desop)
    c:RegisterEffect(e3)	
	
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239902,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCost(c77239902.cost)
    e4:SetTarget(c77239902.target)
    e4:SetOperation(c77239902.operation)
    c:RegisterEffect(e4)
	
    --unaffectable
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetValue(c77239902.efilter)
    c:RegisterEffect(e5)
end
-------------------------------------------------------------------------------------
function c77239902.thfilter(c)
    return c:IsCode(77239910) and c:IsAbleToHand()
end
function c77239902.thfilter1(c)
    return c:IsCode(77239911) and c:IsAbleToHand()
end
function c77239902.thfilter2(c)
    return c:IsCode(77239912) and c:IsAbleToHand()
end
function c77239902.activate1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c77239902.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    local g1=Duel.SelectMatchingCard(tp,c77239902.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    local g2=Duel.SelectMatchingCard(tp,c77239902.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)	
    g:Merge(g1)
    g:Merge(g2)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c77239902.condition(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if Duel.GetAttackTarget()==nil or Duel.GetAttacker()==nil then return end
    return d:IsAttribute(ATTRIBUTE_DARK)
end
function c77239902.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(1500)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
end
function c77239902.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
-------------------------------------------------------------------------------------
function c77239902.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239902.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT) and tc:IsAttribute(ATTRIBUTE_DARK) then
        Duel.Damage(1-tp,1500,REASON_EFFECT)
    end
end
-------------------------------------------------------------------------------------
function c77239902.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c77239902.spfilter1(c,e,tp)
    return (c:IsCode(10000000) or c:IsCode(513000135)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239902.spfilter2(c,e,tp)
    return (c:IsCode(10000010) or c:IsCode(513000134)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239902.spfilter3(c,e,tp)
    return (c:IsCode(10000020) or c:IsCode(513000136)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239902.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
        and Duel.IsExistingTarget(c77239902.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingTarget(c77239902.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingTarget(c77239902.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectTarget(tp,c77239902.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectTarget(tp,c77239902.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g3=Duel.SelectTarget(tp,c77239902.spfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)   
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,4,0,0)
end
function c77239902.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if g:GetCount()>ft then return end
    Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
end
-------------------------------------------------------------------------------------
function c77239902.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end

