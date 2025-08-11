--太阳神的血之祭召
function c77238368.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77238368.tg)
    e1:SetOperation(c77238368.op)
    c:RegisterEffect(e1)
    
    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_SZONE)
    e52:SetOperation(c77238368.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_SZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238368.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_SZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238368.distg2)
    c:RegisterEffect(e54)
end
function c77238368.filter(c,e,tp)
    return c:IsSetCard(0xa210) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c77238368.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c77238368.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp,LOCATION_GRAVE)
end
function c77238368.op(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77238368.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			Duel.PayLPCost(tp,500)
			Duel.SpecialSummonComplete()
			tc=g:GetNext()
        end
    end
end

function c77238368.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
  end
  function c77238368.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
  end