--
local s,id=GetID()
local _RSelecl=Group.RandomSelect
function Group.RandomSelect(g,p,ct)
    if Duel.HasFlagEffect(p,id) then
        local sg=g:Filter(Card.IsControler,nil,1-p)
        if #sg>0 then
            Duel.ConfirmCards(p,sg)
        end
        return g:Select(p,ct,ct,nil)
    end
    return _RSelecl(g,p,ct) 
end
local _SendtoDeck=Duel.SendtoDeck
function Duel.SendtoDeck(g,p,seq,reason,rp,chk)
    if not chk and (Duel.HasFlagEffect(0,id) or Duel.HasFlagEffect(1,id)) and seq and seq==2 then
        local sp=Duel.HasFlagEffect(0,id) and 0 or 1
        Duel.Hint(HINT_SELECTMSG,sp,aux.Stringid(id,0))
        local op=Duel.SelectEffect(sp,
            {true,aux.Stringid(id,1)},
            {true,aux.Stringid(id,2)},
            {true,aux.Stringid(id,3)})
        op=op-1
        chk=true
        return Duel.SendtoDeck(g,p,op,reason,rp,chk)
    end
    return _SendtoDeck(g,p,seq,reason,rp,chk)
end
function s.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(0xff)
    e1:SetCode(EVENT_STARTUP)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetOperation(s.op)
    c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetOwner()
    Duel.DisableShuffleCheck()
    Duel.SendtoDeck(c,nil,-2,REASON_RULE)   
    Duel.RegisterFlagEffect(tp,id,0,0,1)
end