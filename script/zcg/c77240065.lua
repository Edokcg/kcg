--究极幻魔兽-降雷皇
function c77240065.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)

    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77240065.sprcon)
    e2:SetOperation(c77240065.sprop)
    c:RegisterEffect(e2)
	
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c77240065.efilter)
	c:RegisterEffect(e3)
	
    --attack cost
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_ATTACK_COST)
    e4:SetCost(c77240065.atcost)
    e4:SetOperation(c77240065.atop)
    c:RegisterEffect(e4)
	
    --battle indestructable
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e5:SetValue(1)
    e5:SetCondition(c77240065.condition)	
    c:RegisterEffect(e5)	
	
    --cannot select battle target
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(0,LOCATION_MZONE)
    e6:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e6:SetValue(c77240065.atlimit)
    c:RegisterEffect(e6)
end
--------------------------------------------------------------------------
function c77240065.spfilter(c)
    return  c:IsAbleToGraveAsCost()
end
function c77240065.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
    and Duel.IsExistingMatchingCard(c77240065.spfilter,tp,0,LOCATION_ONFIELD,3,nil)
end
function c77240065.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c77240065.spfilter,tp,0,LOCATION_ONFIELD,3,3,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
--------------------------------------------------------------------------
function c77240065.atcost(e,c,tp)
    return Duel.CheckReleaseGroup(1-tp,nil,1,e:GetHandler())
end
function c77240065.atop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectReleaseGroup(1-tp,nil,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
    Duel.Damage(1-tp,g:GetFirst():GetAttack(),REASON_EFFECT)
end
--------------------------------------------------------------------------
function c77240065.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsDefensePos()
end
--------------------------------------------------------------------------
function c77240065.atlimit(e,c)
    return c~=e:GetHandler()
end

function c77240065.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end