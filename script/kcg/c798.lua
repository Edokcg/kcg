-- 邪神 恐惧之源
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

    -- 场上怪兽攻守减半
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SET_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetTarget(s.atktg)
    e3:SetValue(s.atkval)
    c:RegisterEffect(e3)
    local e4 = e3:Clone()
    e4:SetCode(EFFECT_SET_DEFENSE)
    e4:SetValue(s.defval)
    c:RegisterEffect(e4)
    
	local e114=Effect.CreateEffect(c)
	e114:SetType(EFFECT_TYPE_SINGLE)
	e114:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e114:SetCode(EFFECT_ADD_RACE)
	e114:SetValue(RACE_FIEND)
	c:RegisterEffect(e114)
	local e115=e114:Clone()
	e115:SetCode(EFFECT_ADD_ATTRIBUTE)
	e115:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e115)
end
--------------------------------------------------------------------
function s.atktg(e, c)
    return c ~= e:GetHandler()
end
function s.atkval(e, c)
    if c:GetAttack() > 800000 then
        return c:GetAttack()
    else
        return c:GetAttack() / 2
    end
end
function s.defval(e, c)
    if c:GetDefense() > 800000 then
        return c:GetDefense()
    else
        return c:GetDefense() / 2
    end
end