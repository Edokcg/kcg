--奥利哈刚 黑魔导女孩(ZCG)
function c77239234.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77239234.val)
    c:RegisterEffect(e1)
	
    --离场特殊召唤
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetCost(c77239234.cost)
    e2:SetTarget(c77239234.hsptg)
    e2:SetOperation(c77239234.hspop)
    c:RegisterEffect(e2)

	--破坏
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetCondition(c77239234.thcon2)
    e3:SetTarget(c77239234.destg)
    e3:SetOperation(c77239234.desop)
    c:RegisterEffect(e3)
end
----------------------------------------------
function c77239234.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0Xa50) --and c:IsRace(RACE_SPELLCASTER)
end
function c77239234.val(e,c)
    return Duel.GetMatchingGroupCount(c77239234.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*300
end
-----------------------------------------------
function c77239234.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0Xa50) --[[and c:IsRace(RACE_SPELLCASTER)]] and c:IsAbleToRemoveAsCost()
end
function c77239234.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239234.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239234.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77239234.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239234.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
-------------------------------------------------
function c77239234.thcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c77239234.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239234.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tg=g:Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()>0 then
        Duel.Destroy(tg,REASON_EFFECT)
    end
end