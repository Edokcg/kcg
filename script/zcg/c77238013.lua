--地缚神 Immortal(ZCG)
local s,id=GetID()
function s.initial_effect(c)
    c:SetUniqueOnField(1,1,s.unfilter,LOCATION_MZONE)
    --cannot special summon
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e11:SetCode(EFFECT_SPSUMMON_CONDITION)
    e11:SetValue(aux.FALSE)
    c:RegisterEffect(e11)
            --summon with 3 tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(s.ttcon)
    e1:SetOperation(s.ttop)
    if aux.IsKCGScript then
        e1:SetValue(SUMMON_TYPE_TRIBUTE)
    else
        e1:SetValue(SUMMON_TYPE_ADVANCE)
    end
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    e2:SetCondition(s.setcon)
    c:RegisterEffect(e2)
--indestructable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(aux.indoval)
    c:RegisterEffect(e3)
--direct atk
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e6)
   --
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetCondition(s.sdcon)
    c:RegisterEffect(e4)
 --battle target
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(aux.imval1)
    c:RegisterEffect(e5)
    --copy
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_ADJUST)
    e0:SetRange(LOCATION_MZONE)
    e0:SetOperation(s.operation)
    c:RegisterEffect(e0)
end
function s.unfilter(c)
    return c:IsSetCard(0x21) and not Duel.IsPlayerAffectedByEffect(c:GetControler(),77238003)
end
function s.filter(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x21) 
end
function s.codefilter(c,code)
    return c:GetOriginalCode()==code and c:IsSetCard(0x21) 
end
function s.codefilterchk(c,sc)
    return sc:GetFlagEffect(c:GetOriginalCode())>0
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
    g:Remove(s.codefilterchk,nil,e:GetHandler())
    if c:IsFacedown() or #g<=0 then return end
    repeat
        local tc=g:GetFirst()
        local code=tc:GetOriginalCode()
        local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
        c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,0)
        local e0=Effect.CreateEffect(c)
        e0:SetCode(id)
        e0:SetLabel(code)
        e0:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e0,true)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_ADJUST)
        e1:SetRange(LOCATION_MZONE)
        e1:SetLabel(cid)
        e1:SetLabelObject(e0)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetOperation(s.resetop)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1,true)
        g:Remove(s.codefilter,nil,code)
    until #g<=0
end
function s.ttcon(e,c,minc)
    if c==nil then return true end
    return minc<=3 and Duel.CheckTribute(c,3)
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectTribute(tp,c,3,3)
    c:SetMaterial(g)
    Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function s.setcon(e,c,minc)
    if not c then return true end
    return false
end
function s.sdcon(e)
    return not Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
