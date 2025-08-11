--太阳神之黄金巨盾
function c77238362.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c77238362.target)
    e1:SetOperation(c77238362.operation)
    c:RegisterEffect(e1)
    --equip limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c77238362.eqlimit)
    c:RegisterEffect(e2)

    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(c77238362.efilter)
    c:RegisterEffect(e3)

    --
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(c77238362.drcon)
    e4:SetTarget(c77238362.target1)
    e4:SetOperation(c77238362.activate1)
    c:RegisterEffect(e4)
	
   --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_SZONE)
    e52:SetOperation(c77238362.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_SZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238362.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_SZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238362.distg2)
    c:RegisterEffect(e54)	
end
-------------------------------------------------------------------------
function c77238362.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77238362.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end
---------------------------------------------------------------------------
function c77238362.eqlimit(e,c)
    return c:IsSetCard(0xa210)
end
function c77238362.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xa210)
end
function c77238362.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77238362.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77238362.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77238362.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77238362.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c77238362.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
---------------------------------------------------------------------------
function c77238362.drcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=eg:GetFirst()
    local bc=ec:GetBattleTarget()
    return e:GetHandler():GetEquipTarget()==eg:GetFirst() and ec:IsControler(tp)
        and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function c77238362.filter1(c)
    return c:IsAbleToHand()
end
function c77238362.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c77238362.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77238362.filter1,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c77238362.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c77238362.activate1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end

