--奥利哈刚 亚美鲁达(ZCG)
function c77239207.initial_effect(c)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_REPEAT)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c77239207.damcon)
    e2:SetTarget(c77239207.damtg)
    e2:SetOperation(c77239207.damop)
    c:RegisterEffect(e2)

    --cannot be target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e3:SetCondition(c77239207.tgcon)
    e3:SetValue(aux.imval1)
    c:RegisterEffect(e3)
end

function c77239207.damfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa50)
end
function c77239207.damcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c77239207.damfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==tp
end
function c77239207.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local no=Duel.GetMatchingGroupCount(c77239207.damfilter,tp,LOCATION_MZONE,0,nil)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400*no)
end
function c77239207.damop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
      local no=Duel.GetMatchingGroupCount(c77239207.damfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Damage(p,400*no,REASON_EFFECT)
end

function c77239207.tgcon(e)
    return Duel.IsExistingMatchingCard(c77239207.damfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end