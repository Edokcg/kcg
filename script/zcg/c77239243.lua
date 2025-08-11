--奥利哈刚 穿心箭(ZCG)
function c77239243.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTarget(c77239243.target)
    e1:SetOperation(c77239243.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c77239243.eqlimit)
    c:RegisterEffect(e4)

    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DAMAGE)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCondition(c77239243.damcon)
    e5:SetTarget(c77239243.damtg)
    e5:SetOperation(c77239243.damop)
    c:RegisterEffect(e5)
end
------------------------------------------------------
function c77239243.filter(c)
    return c:IsFaceup() and (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
function c77239243.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239243.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239243.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239243.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77239243.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c77239243.eqlimit(e,c)
	return c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174))
end
------------------------------------------------------
function c77239243.damcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    return ec and eg:IsContains(ec)
end
function c77239243.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c77239243.damop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ec=e:GetHandler():GetEquipTarget()
    local d=ec:GetBattleTarget():GetAttack()
    Duel.Damage(p,d,REASON_EFFECT)
end

