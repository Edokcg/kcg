local s, id = GetID()
function s.initial_effect(c)
    aux.god(c,3,id,1)
    local e1 = aux.AddNormalSummonProcedure(c, true, false, 3, 3)
    local e2 = aux.AddNormalSetProcedure(c, true, false, 3, 3)

    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCode(805)
    e5:SetValue(3)
    c:RegisterEffect(e5)

    -- atk check
    local e27 = Effect.CreateEffect(c)
    e27:SetType(EFFECT_TYPE_SINGLE)
    e27:SetCode(id)
    c:RegisterEffect(e27)
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SET_ATTACK_FINAL)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_REPEAT + EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(s.aval)
    c:RegisterEffect(e3)
    local e4 = e3:Clone()
    e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
    e4:SetValue(s.aval)
    c:RegisterEffect(e4)

	local e114=Effect.CreateEffect(c)
	e114:SetType(EFFECT_TYPE_SINGLE)
	e114:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e114:SetCode(EFFECT_ADD_RACE)
	e114:SetValue(RACE_FIEND)
	c:RegisterEffect(e114)
	local e115=e114:Clone()
	e115:SetCode(EFFECT_ADD_ATTRIBUTE)
	e115:SetValue(ATTRIBUTE_DARK|RACE_CREATORGOD)
	c:RegisterEffect(e115)
end
----------------------------------------------------------------------
function s.filter(c)
    return c:IsFaceup() and not c:IsHasEffect(id)
end
function s.aval(e, c)
    local g = Duel.GetMatchingGroup(s.filter, 0, LOCATION_MZONE, LOCATION_MZONE, nil)
    if #g == 0 then
        return 1
    else
        local tg, val = g:GetMaxGroup(Card.GetAttack)
        if not tg:IsExists(aux.TRUE, 1, e:GetHandler()) then
            g:RemoveCard(e:GetHandler())
            tg, val = g:GetMaxGroup(Card.GetAttack)
        end
        return val + 1
    end
end