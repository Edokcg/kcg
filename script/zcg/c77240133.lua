--无名之风
function c77240133.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)	
    e1:SetCondition(c77240133.condition)
    e1:SetTarget(c77240133.target)
    e1:SetOperation(c77240133.activate)
    c:RegisterEffect(e1)
end
function c77240133.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp)
end
function c77240133.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77240133.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(800)
        tc:RegisterEffect(e1)
		--draw
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetCategory(CATEGORY_DRAW)
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e2:SetCode(EVENT_BATTLE_DESTROYING)
        e2:SetTarget(c77240133.drtg)
        e2:SetOperation(c77240133.drop)
        tc:RegisterEffect(e2)
    end
end
function c77240133.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77240133.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end