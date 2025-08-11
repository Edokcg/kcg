--奥利哈刚 绝对黑暗力(ZCG)
function c77239249.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c77239249.target)
    e1:SetOperation(c77239249.operation)
    c:RegisterEffect(e1)  
    --Atk & Def up
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(700)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3) 
    --Equip limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c77239249.eqlimit)
    c:RegisterEffect(e4) 
    --damage
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239249,0))
    e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCondition(c77239249.damcon)
    e5:SetTarget(c77239249.damtg)
    e5:SetOperation(c77239249.damop)
    c:RegisterEffect(e5)
    --destroy sub
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_EQUIP)
    e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e6:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    --e6:SetCondition(aux.IsUnionState)
    e6:SetValue(1)
    c:RegisterEffect(e6)
end
----------------------------------------------------------------------------
function c77239249.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tg=c:GetEquipTarget()
    if chk==0 then return c and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
        and tg and tg:IsReason(REASON_BATTLE+REASON_EFFECT) end
    return Duel.SelectYesNo(tp,aux.Stringid(77239249,1))
end
function c77239249.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
----------------------------------------------------------------------------
function c77239249.damcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    return ec and eg:IsContains(ec)
end
function c77239249.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c77239249.damop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ec=e:GetHandler():GetEquipTarget()
    local d=ec:GetBattleTarget():GetAttack()/2
    if Duel.Damage(p,d,REASON_EFFECT)>0 then
	    Duel.Recover(1-p,d,REASON_EFFECT)
	end
end

----------------------------------------------------------------------------
function c77239249.eqlimit(e,c)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) 
	or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
function c77239249.filter(c)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) 
	or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
function c77239249.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_MZONE and c77239249.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239249.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239249.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77239249.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end

