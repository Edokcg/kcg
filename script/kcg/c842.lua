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
function Duel.SendtoDeck(g,p,seq,reason,rp)
    rp=rp or Duel.GetReasonPlayer()
    if rp==nil then rp=p end
    if Duel.HasFlagEffect(rp,id) and seq and seq==2 then
        Duel.Hint(HINT_SELECTMSG,rp,aux.Stringid(id,0))
        local op=Duel.SelectEffect(rp,
            {true,aux.Stringid(id,1)},
            {true,aux.Stringid(id,2)},
            {true,aux.Stringid(id,3)})
        op=op-1
        return _SendtoDeck(g,p,op,reason,rp)
    end
    return _SendtoDeck(g,p,seq,reason,rp,chk)
end
local _ShuffleDeck=Duel.ShuffleDeck
function Duel.ShuffleDeck(tp)
    local rp=Duel.GetReasonPlayer() or tp
    if Duel.HasFlagEffect(rp,id) and Duel.SelectYesNo(rp,aux.Stringid(id,4)) then
        return
    end
    return _ShuffleDeck(tp)
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