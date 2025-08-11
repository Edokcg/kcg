-- 不死之元素英雄 铁壁炮手(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    -- fusion material
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c, true, true, 77240676, 1, s.ofilter, 1)
    Fusion.AddContactProc(c, s.contactfil, s.contactop, s.splimit)
    -- add counter
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_PHASE + PHASE_BATTLE_START)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(s.ctcon)
    e1:SetOperation(s.ctop)
    c:RegisterEffect(e1)
end
function s.ctcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp and
               Duel.IsExistingMatchingCard(Card.IsPosition, tp, 0, LOCATION_MZONE, 1, nil, POS_DEFENSE)
end
function s.ctop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c:GetAttack())
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_BATTLE)
    c:RegisterEffect(e1)
end
function s.ofilter(c, fc, sumtype, tp)
    return c:IsSetCard(0xa250, fc, sumtype, tp) and c:IsSetCard(0x3008, fc, sumtype, tp) and
               c:IsType(TYPE_MONSTER, fc, sumtype, tp)
end
function s.contactfil(tp)
    return Duel.GetMatchingGroup(function(c)
        return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
    end, tp, LOCATION_ONFIELD + LOCATION_HAND, 0, nil)
end
function s.contactop(g, tp)
    Duel.ConfirmCards(1 - tp, g)
    Duel.SetFusionMaterial(g)
    Duel.SendtoGrave(g, REASON_COST + REASON_MATERIAL)
end
