--太阳神之恶魔的恐吓
function c77238378.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77238378.target1)
    e1:SetOperation(c77238378.activate)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77238378,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetLabel(1)
    e2:SetCondition(c77238378.condition)
    e2:SetTarget(c77238378.target2)
    e2:SetOperation(c77238378.activate)
    c:RegisterEffect(e2)
	
   --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_SZONE)
    e52:SetOperation(c77238378.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_SZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238378.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_SZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238378.distg2)
    c:RegisterEffect(e54)
end
-------------------------------------------------------------------------
function c77238378.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77238378.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end
---------------------------------------------------------------------------
function c77238378.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and tp~=Duel.GetTurnPlayer()
        and Duel.SelectYesNo(tp,aux.Stringid(77238378,1)) then 
        e:SetLabel(1)
        Duel.SetTargetCard(Duel.GetAttacker())
        e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(77238378,2))
    else e:SetLabel(0) end
end
function c77238378.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c77238378.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
    Duel.SetTargetCard(Duel.GetAttacker())
end
function c77238378.activate(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()~=1 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0
        or not e:GetHandler():IsRelateToEffect(e) or not Duel.GetAttacker():IsRelateToEffect(e) then return end
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
    local op=Duel.SelectOption(1-tp,70,71,72)
    Duel.ConfirmCards(1-tp,tc)
    if (op~=0 and tc:IsType(TYPE_MONSTER)) or (op~=1 and tc:IsType(TYPE_SPELL)) or (op~=2 and tc:IsType(TYPE_TRAP)) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
    end
end
