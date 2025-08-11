--奥利哈刚 奇甲之盾(ZCG)
function c77239219.initial_effect(c) 
    --immue a
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c77239219.tg)
    e1:SetValue(c77239219.efilter)
    c:RegisterEffect(e1)
    
    --auto be attacked
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e2:SetValue(c77239219.atlimit)
    c:RegisterEffect(e2) 
    
    --DEFENSE up
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DEFCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BE_BATTLE_TARGET)
    e3:SetCost(c77239219.ducost)
    e3:SetCondition(c77239219.ducon)
    e3:SetOperation(c77239219.duop)
    c:RegisterEffect(e3) 
end
-------------------------------------------------------------------------
function c77239219.tg(e,c)
    return c:IsSetCard(0xa50) --[[or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169)
	or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))]]
end
function c77239219.efilter(e,te)
    return te:GetHandler():GetControler()~=e:GetHandlerPlayer()
end
---------------------------------------------------------------------------
function c77239219.atlimit(e,c)
	return c~=e:GetHandler()
end
---------------------------------------------------------------------------
function c77239219.ducon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler()==Duel.GetAttackTarget()
end
function c77239219.costfilter(c)
    return c:IsAbleToGraveAsCost()
end
function c77239219.ducost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239219.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local cg=Duel.SelectMatchingCard(tp,c77239219.costfilter,tp,LOCATION_HAND,0,1,4,nil)
    Duel.SendtoGrave(cg,REASON_COST)
    e:SetLabel(cg:GetCount())
end
function c77239219.duop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cg=e:GetLabel()*600
    if c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(cg)
        c:RegisterEffect(e1)
    end
end
