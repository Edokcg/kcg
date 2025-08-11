-- Sin サイバー·エンド·ドラゴン
local s, id = GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    -- special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- selfdes
    local e7 = Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_SELF_DESTROY)
    e7:SetCondition(s.descon)
    c:RegisterEffect(e7)

    -- spson
    local e9 = Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e9:SetCode(EFFECT_SPSUMMON_CONDITION)
    e9:SetValue(aux.FALSE)
    c:RegisterEffect(e9)

    -- pierce
    local e10 = Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e10)
end
s.listed_names = {27564031,1546123}

function s.sumlimit(e, c)
    return c:IsSetCard(0x23)
end
function s.exfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x23)
end
function s.excon(e)
    return Duel.IsExistingMatchingCard(c1710476.exfilter, 0, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
end

function s.spfilter(c)
    return c:IsCode(1546123) and c:IsAbleToGraveAsCost()
end
function s.spcon(e, c)
    if c == nil then
        return true
    end
    return Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0 and
               Duel.IsExistingMatchingCard(s.spfilter, c:GetControler(), LOCATION_EXTRA, 0, 1, nil)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
    local tg = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil)
    if #tg<1 then return end
    Duel.SendtoGrave(tg, REASON_COST)
end

function s.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end