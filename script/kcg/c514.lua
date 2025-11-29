--閃光抽牌
local s, id = GetID()
function s.initial_effect(c)
	local ge2 = Effect.CreateEffect(c)
    ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    ge2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    ge2:SetCode(EVENT_PREDRAW)
    ge2:SetCondition(s.drcon)
    ge2:SetOperation(s.drop)
    Duel.RegisterEffect(ge2, 0)
    local ge3 = ge2:Clone()
    Duel.RegisterEffect(ge3, 1)

    local ge4 = Effect.CreateEffect(c)
    ge4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    ge4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    ge4:SetCode(EVENT_PREEFFECT_DRAW)
    ge4:SetCondition(s.drcon2)
    ge4:SetOperation(s.drop2)
    Duel.RegisterEffect(ge4, 0)
    local ge5 = ge4:Clone()
    Duel.RegisterEffect(ge5, 1)

	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(826,1))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.xyzcondition85)
    e1:SetOperation(s.xyzactivate85)
    Duel.RegisterEffect(e1,0)
    local e0 = e1:Clone()
    Duel.RegisterEffect(e0, 1)

    local e2=e1:Clone()
    e2:SetDescription(aux.Stringid(827, 6))
    e2:SetCondition(s.condition32)
    e2:SetOperation(s.activate32)
    e2:SetCountLimit(1)
    Duel.RegisterEffect(e2,0)
    local e3 = e2:Clone()
    Duel.RegisterEffect(e3, 1)
end

function s.ovfilter85(c, tp)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) 
    and c:IsSetCard(0x48) and not c:IsSetCard(0x1048) and not c:IsSetCard(0x2048)
    and not c:IsCode(84013237, 65676461, 31801517) --not No.39,32,62
    and c:GetRank() == c:GetOriginalRank()
    and c:GetRealCode()==0
    and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_XYZ)>0
end
function s.xyzcondition85(e, tp, eg, ep, ev, re, r, rp)
    return (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2) 
    and Duel.GetTurnPlayer() == tp and Duel.GetLP(tp) <= 1000
    and Duel.GetFlagEffect(tp, 91999980) ~= 0
    and Duel.IsExistingMatchingCard(s.ovfilter85, tp, LOCATION_MZONE, 0, 1, nil, tp)
end
function s.xyzactivate85(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
    local ng = Duel.SelectMatchingCard(tp,s.ovfilter85,tp,LOCATION_MZONE,0,1,1,nil,tp)
    if ng:GetCount()~=1 then return end
    local g=Duel.CreateToken(tp,619,nil,nil,nil,nil,nil,nil)
    Duel.SendtoDeck(g, tp, 0, REASON_RULE)
    local og = ng:GetFirst():GetOverlayGroup()
    if og:GetCount() ~= 0 then
        Duel.Overlay(g, og)
    end
    g:SetMaterial(ng)
    Duel.Overlay(g, ng)
    Duel.SpecialSummonStep(g, SUMMON_TYPE_XYZ, tp, tp, true, true, POS_FACEUP)
    aux.xyzchange(g,ng:GetFirst())
    Duel.SpecialSummonComplete()
    g:CompleteProcedure()
end

function s.condition32(e, tp, eg, ep, ev, re, r, rp)
    return (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2) 
    and Duel.GetTurnCount() ~= 1 and tp == Duel.GetTurnPlayer() 
    and Duel.IsExistingMatchingCard(Card.IsSetCard, tp, LOCATION_HAND, 0, 1, nil, 0x95) 
    and Duel.GetLP(tp) <= 2000 
    and Duel.GetFlagEffect(tp, 91999980) ~= 0 and Duel.GetFlagEffect(tp, 89999997) < 4
end
function s.activate32(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetOwner()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, Card.IsSetCard, tp, LOCATION_HAND, 0, 1, 1, nil, 0x95)
    if #g<1 then return end
    local tc = g:GetFirst()
    s.announce_filter = {0x95, OPCODE_ISSETCARD}
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
    local code = Duel.AnnounceCard(tp, 0x95, OPCODE_ISSETCARD,OPCODE_ALLOW_ALIASES)
    local a = Duel.CreateToken(tp, code)
    tc:SetEntityCode(code, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
    if Duel.GetFlagEffect(tp, 89999997) == 1 then
        Duel.Hint(HINT_CARD, 0, 510000103)
    end
    if Duel.GetFlagEffect(tp, 89999997) == 2 then
        Duel.Hint(HINT_CARD, 0, 510000104)
    end
    if Duel.GetFlagEffect(tp, 89999997) == 3 then
        Duel.Hint(HINT_CARD, 0, 510000105)
    end
    Duel.Hint(HINT_MESSAGE, 1 - tp, aux.Stringid(111011901, 2))
    Duel.RegisterFlagEffect(tp, 89999997, 0, 0, 1)
end

function s.drcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp and Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0
end
function s.drop(e, tp, eg, ep, ev, re, r, rp)
    s.KDraw(tp, 1)
end

function s.drcon2(e, tp, eg, ep, ev, re, r, rp)
    return ep == tp and Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0
end
function s.drop2(e, tp, eg, ep, ev, re, r, rp)
    local count = ev
    if ev > count then count = Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) end
    s.KDraw(tp, count)
end

function s.KDraw(ttp, count)
    local e = Effect.GlobalEffect()
    if Duel.GetTurnCount() ~= 1 and Duel.GetMatchingGroupCount(nil, ttp, LOCATION_DECK, 0, nil) > 0 and
        (Duel.GetLP(ttp) <= 2000 and Duel.GetFlagEffect(ttp, 91999980) > 0 and Duel.GetFlagEffect(ttp, 89999997) < 4) then

        if Duel.GetFlagEffect(ttp, 91999980) ~= 0 and Duel.SelectYesNo(ttp, aux.Stringid(827, 6)) then
            local op = Duel.SelectOption(ttp, aux.Stringid(826, 11), aux.Stringid(826, 3))
            local zexal = math.max(1, Duel.GetFlagEffect(ttp, 89999997)) -1
            if zexal > 1 then zexal = 2 end
            Duel.Hint(HINT_AVATAR, ttp, aux.Stringid(514, zexal))
            Duel.Hint(HINT_MUSIC, ttp, aux.Stringid(514, zexal))
            if op == 0 then
                Duel.Hint(HINT_SELECTMSG, ttp, HINTMSG_TARGET)
                local destinytc = Duel.SelectMatchingCard(ttp, nil, ttp, LOCATION_DECK, 0, 1, count, nil)
                if not destinytc then return end
                Duel.ShuffleDeck(ttp) 
                local tacg2 = Duel.GetDecktopGroup(ttp, #destinytc)
                if #tacg2 < 1 then return end
                aux.SwapEntity(destinytc, tacg2)
            end
            if op == 1 then
                local tacg = Duel.GetDecktopGroup(ttp, count)
                for i = 1, count do
                    local tacg1 = Duel.GetDecktopGroup(ttp, 1)
                    if #tacg1<1 or #tacg<1 then return end
                    local tac = tacg:GetFirst()
                    if Duel.SelectYesNo(ttp, aux.Stringid(826, 3)) then
                        local temp = #tacg
                        while temp>1 do
                            tac = tacg:GetNext()
                            temp = temp - 1
                        end
                        Duel.Hint(HINT_SELECTMSG,ttp,HINTMSG_CODE)
                        local code = Duel.AnnounceCard(ttp, 0x7e, OPCODE_ISSETCARD,TYPE_EXTRA, OPCODE_ISTYPE, OPCODE_NOT, OPCODE_AND, SCOPE_CUSTOM, OPCODE_ISOTYPE, OPCODE_NOT, OPCODE_AND, OPCODE_ALLOW_ALIASES)
                        if tac:IsOriginalCode(code) then
                            tacg:RemoveCard(tac)
                        else
                            local tg = Duel.GetMatchingGroup(Card.IsCode, ttp, LOCATION_DECK, 0, tac, code)
                            if #tg>0 then
                                local tgc = tg:GetFirst()
                                tacg:RemoveCard(tac)
                                aux.SwapEntity(tgc, tac)
                            else
                                local token = Duel.CreateToken(ttp, code)
                                Duel.DisableShuffleCheck()
                                Duel.SendtoDeck(token, ttp, 0, REASON_RULE)
                            end
                        end
                    end
                end
            end
            Duel.Hint(HINT_MESSAGE, 1 - ttp, aux.Stringid(111011901, 2))
            Duel.RegisterFlagEffect(ttp, 89999997, 0, 0, 1)
        end
    end
end