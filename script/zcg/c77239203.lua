--奥利哈刚 爱恩哈特(ZCG)
function c77239203.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCondition(c77239203.atcon)
    e1:SetCost(c77239203.atcost)
    e1:SetOperation(c77239203.atop)
    c:RegisterEffect(e1)
    
    --Atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c77239203.tg)
    e2:SetValue(500)
    c:RegisterEffect(e2)
end
-------------------------------------------------------------------------
function c77239203.tg(e,c)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) 
	or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
-------------------------------------------------------------------------
function c77239203.atcon(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return (d~=nil and a:GetControler()==tp and (a:IsSetCard(0xa50) or (a:IsCode(170000166) or a:IsCode(170000167) or a:IsCode(170000168) or a:IsCode(170000169) or a:IsCode(170000170) or a:IsCode(170000171) or a:IsCode(170000172) or a:IsCode(170000174))) and a:IsRelateToBattle())
        or (d~=nil and d:GetControler()==tp and d:IsFaceup() and (d:IsSetCard(0xa50) or (d:IsCode(170000166) or d:IsCode(170000167) or d:IsCode(170000168) or d:IsCode(170000169) or d:IsCode(170000170) or d:IsCode(170000171) or d:IsCode(170000172) or d:IsCode(170000174))) and d:IsRelateToBattle())
end
function c77239203.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77239203.atop(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetAttacker()
    local aatk=a:GetAttack()
    local adef=a:GetDefense()
    local d=Duel.GetAttackTarget()
    local datk=d:GetAttack()
    local ddef=d:GetDefense()
    if aatk<0 then aatk=0 end
    if datk<0 then datk=0 end
    if adef<0 then adef=0 end
    if ddef<0 then ddef=0 end
    if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
    local g=Duel.GetMatchingGroup(c77239203.filter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
     local e1=Effect.CreateEffect(e:GetHandler())
     e1:SetOwnerPlayer(tp)
     e1:SetType(EFFECT_TYPE_SINGLE)
     e1:SetCode(EFFECT_UPDATE_ATTACK)
     e1:SetReset(RESET_EVENT+0x1ff0000)
     if a:GetControler()==tp then
        e1:SetValue(datk)
        a:RegisterEffect(e1)
     else
        e1:SetValue(aatk)
        d:RegisterEffect(e1)
     end
     local e2=Effect.CreateEffect(e:GetHandler())
     e2:SetOwnerPlayer(tp)
     e2:SetType(EFFECT_TYPE_SINGLE)
     e2:SetCode(EFFECT_UPDATE_DEFENSE)
     e2:SetReset(RESET_EVENT+0x1ff0000)
     if a:GetControler()==tp then
        e2:SetValue(ddef)
        a:RegisterEffect(e2)
     else
        e2:SetValue(adef)
        d:RegisterEffect(e2)
     end
     tc=g:GetNext()
    end
end
function c77239203.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xa50)
end