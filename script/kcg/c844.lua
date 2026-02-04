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
        Duel.Draw(0,Duel.GetStartingHand(0)*(Duel.GetPlayersCount(1)-1),REASON_RULE)
    elseif Duel.GetPlayersCount(1)==1 and Duel.GetPlayersCount(0)>1 then
        Duel.Draw(1,Duel.GetStartingHand(1)*(Duel.GetPlayersCount(0)-1),REASON_RULE)
    elseif Duel.GetPlayersCount(0)==1 and Duel.GetPlayersCount(1)==1 then
        if Duel.GetMatchingGroupCount(Card.IsCode, 0, LOCATION_EXTRA, 0, nil, 111) > 0 then
            aux.AIchk[0] = 1
        end
        if Duel.GetMatchingGroupCount(Card.IsCode, 1, LOCATION_EXTRA, 0, nil, 111) > 0 then
            aux.AIchk[1] = 1
        end
        if aux.AIchk[0]==1 then
            Duel.Hint(HINTMSG_NUMBER,1,aux.Stringid(id,0))
            local opt=Duel.AnnounceNumber(1,Duel.GetStartingHand(0)*2,Duel.GetStartingHand(0)*3,Duel.GetStartingHand(0)*4)
            Duel.Draw(0,opt-Duel.GetStartingHand(0),REASON_RULE)
        elseif aux.AIchk[1]==1 then
            Duel.Hint(HINTMSG_NUMBER,0,aux.Stringid(id,0))
            local opt=Duel.AnnounceNumber(0,Duel.GetStartingHand(1)*2,Duel.GetStartingHand(1)*3,Duel.GetStartingHand(1)*4)
            Duel.Draw(1,opt-Duel.GetStartingHand(1),REASON_RULE)
        else
            if Duel.SelectYesNo(0,aux.Stringid(id,0)) then
                Duel.Hint(HINTMSG_NUMBER,0,aux.Stringid(id,0))
                local opt=Duel.AnnounceNumber(0,Duel.GetStartingHand(1)*2,Duel.GetStartingHand(1)*3,Duel.GetStartingHand(1)*4)
                Duel.Draw(1,opt-Duel.GetStartingHand(1),REASON_RULE)
            end
            if Duel.SelectYesNo(1,aux.Stringid(id,0)) then
                Duel.Hint(HINTMSG_NUMBER,1,aux.Stringid(id,0))
                local opt=Duel.AnnounceNumber(1,Duel.GetStartingHand(0)*2,Duel.GetStartingHand(0)*3,Duel.GetStartingHand(0)*4)
                Duel.Draw(0,opt-Duel.GetStartingHand(0),REASON_RULE)
            end
        end
    end


    if Duel.GetMatchingGroupCount(Card.IsCode,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,id)>0 then 
        Duel.DisableShuffleCheck()
        Duel.SendtoDeck(Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,id),0,-2,REASON_RULE)
    end
    e:Reset()
end