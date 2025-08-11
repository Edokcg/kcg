--太阳神之岩石龙
function c77238328.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK)
    e1:SetCondition(c77238328.spcon)
    c:RegisterEffect(e1)
	
    -- 
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77238328,0))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_DAMAGE)
    e2:SetCountLimit(1)	
    e2:SetCondition(c77238328.condition)
    e2:SetOperation(c77238328.operation)
    c:RegisterEffect(e2)

    --to grave
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77238328,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c77238328.con)
    e3:SetTarget(c77238328.target)
    e3:SetOperation(c77238328.activate)
    c:RegisterEffect(e3)
	
    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(c77238328.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238328.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238328.distg2)
    c:RegisterEffect(e54)	
end
-------------------------------------------------------------------------
function c77238328.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77238328.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end
-------------------------------------------------------------------------
function c77238328.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa210)
end
function c77238328.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77238328.spfilter,c:GetControler(),LOCATION_GRAVE,0,2,nil)
end
--------------------------------------------------------------------------
function c77238328.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and Duel.GetAttackTarget()==nil
end
function c77238328.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Damage(1-tp,c:GetDefense(),REASON_EFFECT)
end
--------------------------------------------------------------------------
function c77238328.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
        and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
end
function c77238328.filter(c,e,tp)
    return c:IsCode(77238328) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77238328.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77238328.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77238328.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77238328.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

