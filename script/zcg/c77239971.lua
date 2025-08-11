--決闘甲冑・混沌の黒魔導装
function c77239971.initial_effect(c)
    --synchro summon
    if aux.IsKCGScript then
        Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),1,1,aux.FilterSummonCode(77239970),1,1)
    else
        aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.FilterBoolFunction(Card.IsCode,77239970),1,1)
    end
    c:EnableReviveLimit()
    --Atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetOperation(c77239971.valop)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c77239971.val)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --multi attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
    e4:SetRange(LOCATION_MZONE)
    e4:SetOperation(c77239971.maop)
    c:RegisterEffect(e4)
    --direct attack
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239971,0))
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCost(c77239971.cost)
    e5:SetOperation(c77239971.operation)
    c:RegisterEffect(e5)
    --direct attack
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(77239971,1))
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCost(c77239971.cost1)
    e6:SetOperation(c77239971.operation1)
    c:RegisterEffect(e6)
    --immune
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_IMMUNE_EFFECT)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(c77239971.unval)
    c:RegisterEffect(e7)
end
function c77239971.valop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsSummonType(SUMMON_TYPE_SYNCHRO) then return end
    local g=c:GetMaterial()
    local tc=g:GetFirst()
    local atk=0
    local def=0
    while tc do
        local batk=tc:GetAttack()
        local bdef=tc:GetDefense()
        if batk>0 then
              atk=atk+batk
           end
        if bdef>0 then
              def=def+bdef
          end
        tc=g:GetNext()
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK)
    e1:SetValue(atk)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_DEFENSE)
    e2:SetValue(def)
    c:RegisterEffect(e2)
end
function c77239971.filter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function c77239971.val(e,c)
    return Duel.GetMatchingGroupCount(c77239971.filter,0,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil)*1000
end
function c77239971.maop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetTurnPlayer()~=tp then return end
    local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_SPELL)
    if ct~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(ct)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_BATTLE)
        e:GetHandler():RegisterEffect(e1)
    end
end
function c77239971.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,e:GetHandler(),TYPE_MONSTER) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,e:GetHandler(),TYPE_MONSTER)
    Duel.Release(g,REASON_COST)
end
function c77239971.operation(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c77239971.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function c77239971.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetHandler():IsFaceup() then  
        if aux.IsKCGScript then
            local e1=Effect.CreateEffect(c)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_INF_ATTACK)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            c:RegisterEffect(e1)
        else
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            e1:SetValue(8888888)
            c:RegisterEffect(e1)
        end
    end
end
function c77239971.unval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
