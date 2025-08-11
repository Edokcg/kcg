--冥界恶犬(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    --send to grave
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    --special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(s.target2)
    e1:SetOperation(s.operation2)
    c:RegisterEffect(e1)
end

function s.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa13) and c:IsAbleToGrave()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_DECK, 0, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, tp, LOCATION_DECK)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local g = Duel.SelectMatchingCard(tp, s.tgfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if g:GetCount() > 0 then
        Duel.SendtoGrave(g, REASON_EFFECT)
    end
end

function s.filter(c, e, sp)
    return c:IsSetCard(0xa13) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e, 0, sp, true, true)
end

function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 1
            and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_GRAVE, 0, 2, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_GRAVE)
end

function s.operation2(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 1 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_GRAVE, 0, 2, 2, nil, e, tp)
    if Duel.SpecialSummon(g, 0, tp, tp, true, true, POS_FACEUP) ~= 0 then
        Duel.Draw(tp, 2, REASON_EFFECT)
    end
end
