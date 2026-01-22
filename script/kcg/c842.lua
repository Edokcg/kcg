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
    local e1=Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_STARTUP)
    e1:SetOperation(s.op)
    Duel.RegisterEffect(e1,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectYesNo(0,aux.Stringid(id,5)) then
        Duel.RegisterFlagEffect(0,id,0,0,1)
    end
    if Duel.SelectYesNo(1,aux.Stringid(id,5)) then
        Duel.RegisterFlagEffect(1,id,0,0,1)
    end
    if Duel.GetMatchingGroupCount(Card.IsCode,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,id)>0 then 
        Duel.DisableShuffleCheck()
        Duel.SendtoDeck(Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,id),0,-2,REASON_RULE)
    end
    e:Reset()
end