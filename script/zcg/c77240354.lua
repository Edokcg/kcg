-- 不死之时间魔术师(ZCG)
local s, id = GetID()
function s.initial_effect(c)
    -- destroy
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_COIN)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
    --
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(s.efilter)
    c:RegisterEffect(e1)
end
s.toss_coin = true
function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
end
function s.desop(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_COIN)
    local coin = Duel.AnnounceCoin(tp)
    local res = Duel.TossCoin(tp, 1)
    if coin ~= res then
        local lp1 = Duel.GetLP(tp)
        local lp2 = Duel.GetLP(1 - tp)
        Duel.SetLP(tp, lp2)
        Duel.SetLP(1 - tp, lp1)
    end
end
function s.efilter(e, re)
    return e:GetHandlerPlayer() ~= re:GetHandlerPlayer()
end
