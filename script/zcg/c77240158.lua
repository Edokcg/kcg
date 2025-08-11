--殉道者 火焰战士
function c77240158.initial_effect(c)
    --Remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(6669065,1))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(2)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77240158.condition)
    --e1:SetTarget(c77240158.target)
    e1:SetOperation(c77240158.operation)
    c:RegisterEffect(e1)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240158.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240158.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240158.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77240158.disop)
    c:RegisterEffect(e13)
end
-------------------------------------------------------------
function c77240158.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa60)
end
function c77240158.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(c77240158.filter,tp,LOCATION_GRAVE,0,nil)>0
end

--[[function c77240158.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsAbleToRemove() and chkc:IsType(TYPE_MONSTER) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,nil,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77240158.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
        if tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) and c:IsSetCard(0xa60) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,2)
            e1:SetValue(tc:GetAttack())
            c:RegisterEffect(e1)
        end
    end
end]]

function c77240158.operation(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77240158.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    local tc=g:GetFirst()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(tc:GetAttack())
    e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END,2)
    e:GetHandler():RegisterEffect(e1)
end

function c77240158.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240158.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240158.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end