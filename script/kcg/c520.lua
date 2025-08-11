--Astral Shining Draw
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
    e1:SetDescription(aux.Stringid(826, 2))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(s.xyzcondition852)
    e1:SetOperation(s.xyzactivate852)
    Duel.RegisterEffect(e1,0)
    local e0 = e1:Clone()
    Duel.RegisterEffect(e0, 1)
end

function s.ovfilter85(c, tp)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) 
    and c:IsSetCard(0x48) and not c:IsSetCard(0x1048) and not c:IsSetCard(0x2048)
    and not c:IsCode(84013237, 65676461, 37279508, 63767246, 23187256) --not No.39,32,37,38,93
    and c:GetRank() == c:GetOriginalRank()
    and c:GetRealCode()==0
    and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_XYZ)>0
end

function s.xyzcondition852(e, tp, eg, ep, ev, re, r, rp)
    return (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2) 
    and Duel.GetTurnPlayer() == tp and Duel.GetLP(tp) <= 1000
    and Duel.GetFlagEffect(tp, 388) ~= 0
    and Duel.IsExistingMatchingCard(s.ovfilter85, tp, LOCATION_MZONE, 0, 1, nil, tp)
end
function s.xyzactivate852(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
    local ng = Duel.SelectMatchingCard(tp,s.ovfilter85,tp,LOCATION_MZONE,0,1,1,nil,tp)
    if ng:GetCount() ~= 1 then return end
    local g = Duel.CreateToken(tp, 620, nil, nil, nil, nil, nil, nil)
    Duel.SendtoDeck(g, tp, 0, REASON_RULE)
    local og = ng:GetFirst():GetOverlayGroup()
    if og:GetCount() ~= 0 then
        Duel.Overlay(g, og)
    end
    g:SetMaterial(ng)
    Duel.Overlay(g, ng)
    Duel.SpecialSummonStep(g, SUMMON_TYPE_XYZ, tp, tp, true, true, POS_FACEUP)
    aux.xyzchange(g, ng:GetFirst())
    Duel.SpecialSummonComplete()
    g:CompleteProcedure()
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
        Duel.GetFlagEffect(ttp, 388) ~= 0 then

        if Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK, 0, nil, 0x95) > 0 and Duel.SelectYesNo(ttp, aux.Stringid(13713, 8)) then
            Duel.Hint(HINT_SELECTMSG, ttp, HINTMSG_TARGET)
            local destinytc = Duel.SelectMatchingCard(ttp, Card.IsSetCard, ttp, LOCATION_DECK, 0, 1, 1, nil, 0x95):GetFirst()
            if not destinytc then return end
            Duel.ShuffleDeck(ttp) 
            local tacg2 = Duel.GetDecktopGroup(ttp, 1)
            if #tacg2<1 then return end
            local tac2 = tacg2:GetFirst()
            aux.SwapEntity(destinytc, tac2)
            Duel.Hint(HINT_MESSAGE, 1 - ttp, aux.Stringid(13713, 8))
        end
    end
end