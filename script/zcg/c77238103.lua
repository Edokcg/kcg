-- 不死之青眼究极龙
function c77238103.initial_effect(c)
    c:EnableReviveLimit()

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e0)

    local e1 = Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77238103.ttcon)
    e1:SetOperation(c77238103.ttop)
    e1:SetValue(SUMMON_TYPE_TRIBUTE)
    c:RegisterEffect(e1)
    --[[summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77238103,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77238103.otcon)
    e1:SetOperation(c77238103.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    c:RegisterEffect(e2)]]

    -- spsummon
    local e5 = Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77238103, 1))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetOperation(c77238103.activate)
    c:RegisterEffect(e5)
end
-------------------------------------------------------------------
--[[function c77238103.otfilter(c,tp)
    return c:IsRace(RACE_ZOMBIE) and (c:IsControler(tp) or c:IsFaceup())
end
function c77238103.otcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77238103.otfilter,tp,LOCATION_MZONE,0,nil,tp)
    return minc<=1 and Duel.CheckTribute(c,3,3,mg)
end
function c77238103.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77238103.otfilter,tp,LOCATION_MZONE,0,nil,tp)
    local sg=Duel.SelectTribute(tp,c,3,3,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end]]
function c77238103.otfilter(c, tp)
    return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER)
end

function c77238103.ttcon(e, c, minc)
    if c == nil then
        return true
    end
    local tp = c:GetControler()
    local mg = Duel.GetMatchingGroup(c77238103.otfilter, tp, LOCATION_MZONE, 0, nil, tp)
    return minc <= 1 and Duel.CheckTribute(c, 3, 3, mg)
end

function c77238103.ttop(e, tp, eg, ep, ev, re, r, rp, c)
    local mg = Duel.GetMatchingGroup(c77238103.otfilter, tp, LOCATION_MZONE, 0, nil, tp)
    local sg = Duel.SelectTribute(tp, c, 3, 3, mg)
    c:SetMaterial(sg)
    Duel.Release(sg, REASON_SUMMON + REASON_MATERIAL)
end
-------------------------------------------------------------------
function c77238103.activate(e, tp, eg, ep, ev, re, r, rp)
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetTargetRange(LOCATION_ONFIELD, 0)
    e1:SetValue(c77238103.efilter)
    e1:SetReset(RESET_EVENT + 0x1fe0000 + RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e1, tp)
    local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
    local g1 = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_SZONE, nil)
    if g:GetCount() >= 0 and g1:GetCount() >= 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
        local op1 = Duel.SelectOption(tp, aux.Stringid(77238103, 0), aux.Stringid(77238103, 1))
        if op1 == 0 then
            Duel.Destroy(g, REASON_EFFECT)
        else
            Duel.Destroy(g1, REASON_EFFECT)
        end
    elseif g:GetCount() > 0 and g1:GetCount() < 0 then
        Duel.Destroy(g, REASON_EFFECT)
    elseif g:GetCount() < 0 and g1:GetCount() > 0 then
        Duel.Destroy(g1, REASON_EFFECT)
    end
end
function c77238103.efilter(e, te)
    return te:GetHandler():GetControler() ~= e:GetHandlerPlayer()
end
