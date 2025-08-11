--传说骑士-海聶兽斯 城之内仪式
function c77240044.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77240044.spcon)
    c:RegisterEffect(e1)

    --equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77240044,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c77240044.eqtg)
    e2:SetOperation(c77240044.eqop)
    c:RegisterEffect(e2)

    --cannot trigger
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TRIGGER)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,0xa)
    e3:SetTarget(c77240044.distg)
    c:RegisterEffect(e3)

	--跳过回合
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10000000,0))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCost(c77240044.spcost)
    e4:SetCondition(c77240044.tgcon)
    e4:SetOperation(c77240044.tgop)
    c:RegisterEffect(e4)
end
----------------------------------------------------------------
function c77240044.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
----------------------------------------------------------------
function c77240044.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77240044.eqlimit(e,c)
    return e:GetOwner()==c
end
function c77240044.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if c:IsFaceup() and c:IsRelateToEffect(e) then
            local atk=tc:GetAttack()
            if tc:IsFacedown() then atk=0 end
            if atk<0 then atk=0 end
            if not Duel.Equip(tp,tc,c,false) then return end
            e:SetLabelObject(tc)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c77240044.eqlimit)
            tc:RegisterEffect(e1)
            if atk>0 then
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_EQUIP)
                e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
                e2:SetCode(EFFECT_UPDATE_ATTACK)
                e2:SetReset(RESET_EVENT+0x1fe0000)
                e2:SetValue(atk)
                tc:RegisterEffect(e2)
            end
            local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_EQUIP)
        e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetCode(6669251)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e3)
		if c:IsFaceup() and tc:IsFaceup() then
            local code=tc:GetOriginalCode()
            local e4=Effect.CreateEffect(c)
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e4:SetCode(EFFECT_CHANGE_CODE)
            e4:SetValue(code)
            e4:SetReset(RESET_EVENT+0x1fe0000)
            c:RegisterEffect(e4)
            c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
            end
        else Duel.SendtoGrave(tc,REASON_EFFECT) end
    end
end
function c77240044.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local eq=e:GetHandler():GetEquipTarget()
    local code=c:GetOriginalCode()
    eq:CopyEffect(code,RESET_EVENT+0x1fe0000)
end
--------------------------------------------------------------------
function c77240044.distg(e,c)
    return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
--------------------------------------------------------------------
function c77240044.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77240044.costfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c77240044.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240044.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,c77240044.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c77240044.tgop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_SKIP_TURN)
    e1:SetTargetRange(0,1)
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    Duel.RegisterEffect(e1,tp)
end
