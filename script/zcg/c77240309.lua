--冥界守护者 曼托(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.FALSE)
    c:RegisterEffect(e0)
    --special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 1))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    c:RegisterEffect(e1)
    --copy
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 2))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
end

function s.spcon(e, c)
    if c == nil then return true end
    return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0 and
        Duel.GetMatchingGroupCount(Card.IsSetCard, c:GetControler(), LOCATION_GRAVE, 0, nil, 0xa13) >= 3
end

function s.cofilter(c)
    return c:IsSetCard(0xa13) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return s.cofilter(chkc) and chkc:GetLocation() == LOCATION_GRAVE end
    if chk == 0 then return Duel.IsExistingTarget(s.cofilter, tp, LOCATION_GRAVE, 0, 1, nil) and e:GetHandler():GetFlagEffect(id) < 3 end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectTarget(tp, s.cofilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, 1, tp, LOCATION_GRAVE)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
        if Duel.Remove(tc, POS_FACEUP, REASON_EFFECT) ~= 1 then return end
        local code = tc:GetCode()
        c:CopyEffect(code, RESET_EVENT + RESETS_STANDARD, 1)
        c:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD, 0, 1)
    end
end
