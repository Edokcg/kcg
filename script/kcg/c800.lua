local s, id = GetID()
function s.initial_effect(c)
    aux.god(c,3,id,1)
    local e1 = aux.AddNormalSummonProcedure(c, true, false, 3, 3)
    local e2 = aux.AddNormalSetProcedure(c, true, false, 3, 3)

    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCode(805)
    e5:SetValue(2)
    c:RegisterEffect(e5)

    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(id)
	c:RegisterEffect(e0)
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetCondition(function(e) return e:GetHandler():IsHasEffect(id) end)
	e4:SetValue(s.adval)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e3)

    local e6 = Effect.CreateEffect(c)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
    e6:SetDescription(aux.Stringid(800, 2))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_TO_GRAVE)
    e6:SetCondition(s.erascon)
    e6:SetTarget(s.erastg)
    e6:SetOperation(s.erasop)
    c:RegisterEffect(e6)

	local e114=Effect.CreateEffect(c)
	e114:SetType(EFFECT_TYPE_SINGLE)
	e114:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e114:SetCode(EFFECT_ADD_RACE)
	e114:SetValue(RACE_FIEND|RACE_DRAGON)
	c:RegisterEffect(e114)
	local e115=e114:Clone()
	e115:SetCode(EFFECT_ADD_ATTRIBUTE)
	e115:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e115)
end
-----------------------------------------------------------------------
function s.adval(e, c)
    return Duel.GetFieldGroupCount(e:GetHandler():GetControler(), 0, LOCATION_ONFIELD) * 1000
end
-----------------------------------------------------------------------
function s.erascon(e, tp, eg, ep, ev, re, r, rp)
    return not (re and re:GetHandler() and re:GetHandler():IsCode(132))
end
function s.erastg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    local dg = Duel.GetMatchingGroup(nil, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, dg, dg:GetCount(), 0, 0)
end
function s.erasop(e, tp, eg, ep, ev, re, r, rp)
    local dg = Duel.GetMatchingGroup(nil, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
    Duel.Destroy(dg, REASON_RULE+REASON_EFFECT)
end