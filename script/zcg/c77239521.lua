--女子佣兵 薄姬(ZCG)
function c77239521.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetOperation(c77239521.spop)
    c:RegisterEffect(e1)
	
    --to grave
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239521,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetTarget(c77239521.tgtg)
    e2:SetOperation(c77239521.tgop)
    c:RegisterEffect(e2)	
end
----------------------------------------------------------------------
function c77239521.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(c77239521.efilter)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e3)
end
function c77239521.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
----------------------------------------------------------------------
function c77239521.filter2(c)
    return c:IsSetCard(0xa80) and c:IsAbleToHand()
end
function c77239521.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239521.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c77239521.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tc=Duel.SelectMatchingCard(tp,c77239521.filter2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
    if tc then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end