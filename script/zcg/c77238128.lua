-- 不死之亡灵的手腕
function c77238128.initial_effect(c)
    -- double tribute
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
    e1:SetValue(c77238128.condition)
    c:RegisterEffect(e1)

    -- search
    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_RELEASE)
    e2:SetCondition(c77238128.condition1)
    e2:SetTarget(c77238128.target)
    e2:SetOperation(c77238128.operation)
    c:RegisterEffect(e2)

    -- search
    local e3 = Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c77238128.condition2)
    e3:SetTarget(c77238128.target2)
    e3:SetOperation(c77238128.operation)
    c:RegisterEffect(e3)
end
------------------------------------------------------------------------
function c77238128.condition(e, c)
    return c:IsRace(RACE_ZOMBIE)
end
------------------------------------------------------------------------
function c77238128.condition1(e, tp, eg, ep, ev, re, r, rp)
    e:SetLabel(e:GetHandler():GetPreviousControler())
    return e:GetHandler():IsReason(REASON_SUMMON)
end
function c77238128.condition2(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_EFFECT)
end
function c77238128.filter(c)
    return
        (c:IsCode(77240379) or c:IsCode(77240380) or c:IsCode(77238127) or c:IsCode(77238128) or c:IsCode(77238126)) and
            c:IsAbleToHand()
end
function c77238128.target2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(c77238128.filter, tp, LOCATION_DECK, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end
function c77238128.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(c77238128.filter, tp, LOCATION_DECK, 0, 1, nil) and
                   Duel.CheckEvent(EVENT_SUMMON_SUCCESS) or Duel.CheckEvent(EVENT_MSET)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end
function c77238128.operation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectMatchingCard(tp, c77238128.filter, tp, LOCATION_DECK, 0, 1, 1, nil)
    if g:GetCount() > 0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, g)
    end
end

