--奥利哈刚 黑暗磁场(ZCG)
function c77239242.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTarget(c77239242.target)
    e1:SetOperation(c77239242.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c77239242.eqlimit)
    c:RegisterEffect(e4)

    --cannot act spell
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(0,1)
    e3:SetCondition(c77239242.con)
    e3:SetValue(c77239242.aclimit)
    c:RegisterEffect(e3) 
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetTargetRange(0,LOCATION_SZONE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c77239242.con)
    e2:SetTarget(c77239242.distg)
    c:RegisterEffect(e2)
end
------------------------------------------------------
function c77239242.filter(c)
    return c:IsFaceup() and (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
function c77239242.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239242.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239242.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239242.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77239242.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c77239242.eqlimit(e,c)
	return c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174))
end
------------------------------------------------------
function c77239242.distg(e,c)
    return c:IsType(TYPE_SPELL)
end
function c77239242.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c77239242.con(e)
    return e:GetHandler():GetEquipTarget()~=nil
end

