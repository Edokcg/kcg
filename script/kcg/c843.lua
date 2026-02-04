--
local s,id=GetID()
function s.initial_effect(c)
    --
    local e1=Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_STARTUP)
    e1:SetOperation(s.op)
    Duel.RegisterEffect(e1,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetPlayersCount(0)==1 and Duel.GetPlayersCount(1)>1 then
        Duel.SetLP(0,Duel.GetLP(0)*Duel.GetPlayersCount(1))
    elseif Duel.GetPlayersCount(1)==1 and Duel.GetPlayersCount(0)>1 then
        Duel.TagSwap(0)
        Duel.SetLP(1,Duel.GetLP(1)*Duel.GetPlayersCount(0))
    elseif Duel.GetPlayersCount(0)==1 and Duel.GetPlayersCount(1)==1 then
        if Duel.GetMatchingGroupCount(Card.IsCode, 0, LOCATION_EXTRA, 0, nil, 111) > 0 then
            aux.AIchk[0] = 1
        end
        if Duel.GetMatchingGroupCount(Card.IsCode, 1, LOCATION_EXTRA, 0, nil, 111) > 0 then
            aux.AIchk[1] = 1
        end
        if aux.AIchk[0]==1 then
            Duel.Hint(HINTMSG_NUMBER,1,aux.Stringid(id,0))
            local opt=Duel.AnnounceNumber(1,Duel.GetLP(0)/4,Duel.GetLP(0)/2,Duel.GetLP(0)*2,Duel.GetLP(0)*4)
            Duel.SetLP(0,opt)
        elseif aux.AIchk[1]==1 then
            Duel.Hint(HINTMSG_NUMBER,0,aux.Stringid(id,0))
            local opt=Duel.AnnounceNumber(0,Duel.GetLP(1)/4,Duel.GetLP(1)/2,Duel.GetLP(1)*2,Duel.GetLP(1)*4)
            Duel.SetLP(1,opt)
        else
            if Duel.SelectYesNo(0,aux.Stringid(id,0)) then
                Duel.Hint(HINTMSG_NUMBER,0,aux.Stringid(id,0))
                local opt=Duel.AnnounceNumber(0,Duel.GetLP(1)/4,Duel.GetLP(1)/2,Duel.GetLP(1)*2,Duel.GetLP(1)*4)
                Duel.SetLP(1,opt)
            end
            if Duel.SelectYesNo(1,aux.Stringid(id,0)) then
                Duel.Hint(HINTMSG_NUMBER,1,aux.Stringid(id,0))
                local opt=Duel.AnnounceNumber(1,Duel.GetLP(0)/4,Duel.GetLP(0)/2,Duel.GetLP(0)*2,Duel.GetLP(0)*4)
                Duel.SetLP(0,opt)
            end
        end
    end


    if Duel.GetMatchingGroupCount(Card.IsCode,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,id)>0 then 
        Duel.DisableShuffleCheck()
        Duel.SendtoDeck(Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,id),0,-2,REASON_RULE)
    end
    e:Reset()
end