--殉道者 外骨骼兽
function c77240167.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c77240167.eqtg)
    e1:SetOperation(c77240167.eqop)
    c:RegisterEffect(e1)

    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetOperation(c77240167.disop)
    c:RegisterEffect(e2)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240167.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240167.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240167.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77240167.disop)
    c:RegisterEffect(e13)
end
----------------------------------------------------------------------
function c77240167.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa60)
end
function c77240167.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c77240167.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c77240167.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77240167.eqlimit(e,c)
    return e:GetOwner()==c
end
function c77240167.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
        if c:IsFaceup() and c:IsRelateToEffect(e) then
            if not Duel.Equip(tp,tc,c,false) then return end
            --Add Equip limit
            tc:RegisterFlagEffect(4252828,RESET_EVENT+0x1fe0000,0,0)
            e:SetLabelObject(tc)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c77240167.eqlimit)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_EQUIP)
            e2:SetCode(EFFECT_UPDATE_ATTACK)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            e2:SetValue(tc:GetAttack())
            tc:RegisterEffect(e2)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_EQUIP)
            e3:SetCode(EFFECT_UPDATE_DEFENSE)
            e3:SetReset(RESET_EVENT+0x1fe0000)
            e3:SetValue(tc:GetDefense())
            tc:RegisterEffect(e3)
        else Duel.SendtoGrave(tc,REASON_EFFECT) end
    end
end
----------------------------------------------------------------------
function c77240167.disop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    if tc then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2,true)
    end
end
----------------------------------------------------------------------
function c77240167.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240167.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240167.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end