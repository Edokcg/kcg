local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=85
if self_code then id=self_code end
if not DestinyDraw then
    DestinyDraw={}
    -- Announce = {}
    aux.GlobalCheck(DestinyDraw, function()
        aux.AIchk[0] = 0
        aux.AIchk[1] = 0
        -- Announce[0] = {827}
        -- Announce[1] = {827}
    end)
    local function finishsetup()
        local e1 = Effect.GlobalEffect()
        e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_STARTUP)
        e1:SetOperation(DestinyDraw.op)
        Duel.RegisterEffect(e1, 0)
    end

    function DestinyDraw.op(e, tp, eg, ep, ev, re, r, rp)
        for _,card in ipairs(selfs) do
			Duel.SendtoDeck(card,0,-2,REASON_RULE) --exile this card
		end
        local excg=Duel.GetMatchingGroup(function(c) return c:IsOType(SCOPE_CUSTOM) end,0,0xff,0xff,nil)
        Duel.SendtoDeck(excg, 0, -2, REASON_RULE)
		Duel.DisableShuffleCheck()

        local e1 = Effect.GlobalEffect()
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_DELAY)
        e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_SPSUMMON_SUCCESS)
        e1:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
        e1:SetCondition(DestinyDraw.xyzsumcon)
        e1:SetOperation(DestinyDraw.xyzsumop)
        Duel.RegisterEffect(e1, tp)
        local e2=e1:Clone()
        e2:SetCondition(DestinyDraw.removecon)
        e2:SetOperation(DestinyDraw.removeop)
        Duel.RegisterEffect(e2, tp)

        Duel.LoadCardScript("c98.lua")
        Duel.LoadCardScript("c257.lua")	

        local counts = {}
		counts[0] = Duel.GetPlayersCount(0)
		counts[1] = Duel.GetPlayersCount(1)

		local z,o = tp, 1-tp
		for ttp = z, o do
            if Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_EXTRA, 0, nil, 111) > 0 then
				aux.AIchk[ttp] = 1
			end

            for team=1,counts[ttp] do
                local b1 = (Duel.GetMatchingGroupCount(DestinyDraw.DDfiler, ttp, LOCATION_EXTRA, 0, nil) > 0 and Duel.GetMatchingGroupCount(DestinyDraw.DDfiler2, ttp, LOCATION_EXTRA, 0, nil) > 0) --barian
                local b2 = (Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_EXTRA, 0, nil, 0x7f) > 4) --zexal
                local b3 = (Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0x46) > 2 
                    and Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0x3008) > 9) --judai
                local b4 = (Duel.GetMatchingGroupCount(DestinyDraw.RDSfiler, ttp, LOCATION_EXTRA, 0, nil) > 0 
                or (Duel.GetMatchingGroupCount(DestinyDraw.RRDSfiler, ttp, LOCATION_EXTRA, 0, nil) > 0
                    and Duel.GetMatchingGroupCount(DestinyDraw.RRDSfiler2, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 1) > 0)) --yusei
                local b5 = (Duel.GetMatchingGroupCount(DestinyDraw.DTMfiler, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil) > 0 
                    and Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 15259703) > 0) --toon
                local b6 = (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 10000020) > 0 
                    and Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 10000000) > 0 
                    and Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 10000010) > 0) --atem
                local b7 = (Duel.GetMatchingGroupCount(Card.IsType, ttp, LOCATION_DECK, 0, nil, TYPE_FIELD) > 0)
                local nog = Duel.GetMatchingGroup(Card.IsSetCard, ttp, LOCATION_EXTRA, 0, nil, 0x48)
                local b8 = (nog:GetClassCount(Card.GetCode) >= 100 
                    and Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0x505) > 9) --astral
                local b9 = (Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0x5) > 9) --acardia
                local b10 = (Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0x9f) + Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0xf8) > 9) --yuya
                local b11 = (Duel.GetMatchingGroupCount(DestinyDraw.linkcyber, ttp, LOCATION_EXTRA, 0, nil) > 9) --playmaker
                local b12 = ((Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 69890967) > 0) 
                    and (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 32491822) > 0) 
                    and (Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 6007213) > 0)
                    and (Duel.GetMatchingGroupCount(Card.IsType, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, TYPE_SPELL) > 2
                    and Duel.GetMatchingGroupCount(Card.IsType, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, TYPE_TRAP) > 2 
                    and Duel.GetMatchingGroupCount(DestinyDraw.phantom, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil) > 2)) --phantom
                local b13 = (Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_EXTRA + LOCATION_DECK + LOCATION_HAND, 0, nil, 0x23)  > 9 and Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 27564031) > 0) --sin
                local b14 = ((Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 100000055, 100000066, 100000067) > 0) 
                    and Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0x525) > 0 
                    and Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0x507) > 0  
                    and Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0x50d) > 0 
                    and Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0x557) > 0  
                    and Duel.GetMatchingGroupCount(Card.IsSetCard, ttp, LOCATION_DECK + LOCATION_HAND, 0, nil, 0x3013) > 0) --meklord
                        
                local sel = 0
                local off = 1
                local ops = {}
                local opval = {}
                if b1 or b2 or b3 or b4 or b5 or b6 or b7 or b8 or b9 or b10 or b11 or b12 or b13 or b14 then
                    ops[off] = aux.Stringid(826, 12)
                    opval[off - 1] = 1
                    off = off + 1
                end
                ops[off] = aux.Stringid(826, 0)
                opval[off - 1] = 2
                off = off + 1
                local op = Duel.SelectOption(ttp, table.unpack(ops))
                if opval[op] == 2 then
                    Duel.Hint(HINT_SELECTMSG,ttp,HINTMSG_CODE)
                    local code = Duel.AnnounceCard(ttp, TYPE_SKILL, OPCODE_ISTYPE, SCOPE_HIDDEN, OPCODE_ISOTYPE, OPCODE_NOT, OPCODE_AND)
                    local token = Duel.CreateToken(ttp, code)
                    if token.skill_type==nil and token.coverNum2==nil then return end
                    local e1=Effect.CreateEffect(token)
                    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_ULTIMATE_IMMUNE)
                    token:RegisterEffect(e1)
                    if token.skill_type==0 then
                        aux.drawlessop(e1)
                    elseif token.skill_type==1 then
                        Duel.MoveToField(token,ttp,ttp,LOCATION_SZONE,POS_FACEDOWN,true,(1 << 2))
                        if token.flip then
                            Duel.ChangePosition(token,POS_FACEUP)
                        end
                        aux.drawlessop(e1)
                    elseif token.skill_type==2 then
                        aux.SetSkillOp(token.coverNum,token.skillcon,token.skillop,token.countlimit,EVENT_FREE_CHAIN)(e1,ttp,eg,ep,ev,re,r,rp)
                        aux.drawlessop(e1)
                    end
                    if token.coverNum2~=nil then
                        aux.SetSkillOp(token.coverNum2,token.skillcon2,token.skillop2,token.countlimit2,EVENT_PREDRAW)(e1,ttp,eg,ep,ev,re,r,rp)
                        aux.drawlessop(e1)
                    end
                    if token.skill_type==3 then
                        aux.SetVrainsSkillOp(token.skillcon,token.skillop,token.efftype or EVENT_FREE_CHAIN)(e1,ttp,eg,ep,ev,re,r,rp)
                    end
                    local mt=token:GetMetatable()
                    if mt.startop~=nil then
                        for _,te in ipairs(mt.startop) do
                            local chk=false
                            if mt.startopex~=nil then
                                for _,ex in ipairs(mt.startopex) do
                                    if ex==te then chk=true break end
                                end
                            end
                            if not chk then te:GetOperation()(e1,ttp,eg,ep,ev,re,r,rp) end
                        end
                    end
                end
                
                local tt
                if opval[op] == 1 then
                    local sel = 0
                    local off = 1
                    local ops = {}
                    local opval = {}
                    if b1 then
                        ops[off] = aux.Stringid(123106, 8)
                        opval[off - 1] = 1
                        off = off + 1
                    end
                    if b2 then
                        ops[off] = aux.Stringid(111011901, 2)
                        opval[off - 1] = 2
                        off = off + 1
                    end
                    if b3 then
                        ops[off] = aux.Stringid(123106, 11)
                        opval[off - 1] = 3
                        off = off + 1
                    end
                    if b4 then
                        ops[off] = aux.Stringid(517, 1)
                        opval[off - 1] = 4
                        off = off + 1
                    end
                    if b5 then
                        ops[off] = aux.Stringid(826, 7)
                        opval[off - 1] = 5
                        off = off + 1
                    end
                    if b6 then
                        ops[off] = aux.Stringid(826, 6)
                        opval[off - 1] = 6
                        off = off + 1
                    end
                    if b7 then
                        ops[off] = aux.Stringid(48934760, 0)
                        opval[off - 1] = 7
                        off = off + 1
                    end
                    if b8 then
                        ops[off] = aux.Stringid(13713, 8)
                        opval[off - 1] = 8
                        off = off + 1
                    end
                    if b9 then
                        ops[off] = aux.Stringid(23846921, 0)
                        opval[off - 1] = 9
                        off = off + 1
                    end
                    if b10 then
                        ops[off] = aux.Stringid(827, 1)
                        opval[off - 1] = 10
                        off = off + 1
                    end
                    if b11 then
                        ops[off] = aux.Stringid(826, 5)
                        opval[off - 1] = 11
                        off = off + 1
                    end
                    if b12 then
                        ops[off] = aux.Stringid(826, 10)
                        opval[off - 1] = 12
                        off = off + 1
                    end
                    if b13 then
                        ops[off] = aux.Stringid(827, 5)
                        opval[off - 1] = 13
                        off = off + 1
                    end
                    if b14 then
                        ops[off] = aux.Stringid(827, 7)
                        opval[off - 1] = 14
                        off = off + 1
                    end
                    local op = Duel.SelectOption(ttp, table.unpack(ops))
                    if opval[op] == 1 then
                        Duel.RegisterFlagEffect(ttp, 90999980, 0, 0, 1)
                        tt = Duel.CreateToken(ttp, 513)
                        Duel.Hint(HINT_SKILL,ttp,513)
                    end
                    if opval[op] == 2 then
                        Duel.RegisterFlagEffect(ttp, 91999980, 0, 0, 1)
                        tt = Duel.CreateToken(ttp, 514)
                        Duel.Hint(HINT_SKILL,ttp,514)
                    end
                    if opval[op] == 3 then
                        Duel.RegisterFlagEffect(ttp, 92999980, 0, 0, 1)
                        tt = Duel.CreateToken(ttp, 515)
                        Duel.Hint(HINT_SKILL,ttp,515)
                    end
                    if opval[op] == 4 then
                        Duel.RegisterFlagEffect(ttp, 93999980, 0, 0, 1)
                        tt = Duel.CreateToken(ttp, 517)
                        Duel.Hint(HINT_SKILL,ttp,517)
                    end
                    if opval[op] == 5 then
                        Duel.RegisterFlagEffect(ttp, 90899980, 0, 0, 1)
                        tt = Duel.CreateToken(ttp, 518)
                        Duel.Hint(HINT_SKILL,ttp,518)
                    end
                    if opval[op] == 6 then
                        Duel.RegisterFlagEffect(ttp, 90799980, 0, 0, 1)
                        tt = Duel.CreateToken(ttp, 519)
                        Duel.Hint(HINT_SKILL,ttp,519)
                    end
                    if opval[op] == 7 then
                        Duel.Hint(HINT_SELECTMSG, ttp, HINTMSG_TARGET)
                        local field = Duel.SelectMatchingCard(ttp, Card.IsType, ttp, LOCATION_DECK, 0, 1, 1, nil, TYPE_FIELD):GetFirst()
                        if not field then return end
                        Duel.ShuffleDeck(ttp)
                        local tac2=Duel.GetDecktopGroup(ttp, 1):GetFirst()
                        if not tac2 then return end
                        aux.SwapEntity(field, tac2)
                    end
                    if opval[op] == 8 then
                        Duel.RegisterFlagEffect(ttp, 388, 0, 0, 1)
                        local token2=Duel.CreateToken(ttp, 36)
                        local tokeng=Group.FromCards(token1,token2)
                        Duel.SendtoDeck(tokeng, nil, 0, REASON_RULE)
                        tt = Duel.CreateToken(ttp, 520)
                        Duel.Hint(HINT_SKILL, ttp, 520)
                    end
                    if opval[op] == 9 then
                        local e3 = Effect.GlobalEffect()
                        e3:SetType(EFFECT_TYPE_FIELD)
                        e3:SetCode(73206827)
                        e3:SetTargetRange(LOCATION_ONFIELD, LOCATION_ONFIELD)
                        e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard, 0x5))
                        e3:SetCondition(aux.effectcon)
                        Duel.RegisterEffect(e3, ttp)
                    end
                    if opval[op] == 10 then
                        Duel.RegisterFlagEffect(ttp, 703, 0, 0, 1)
                        tt = Duel.CreateToken(ttp, 521)
                        Duel.Hint(HINT_SKILL,ttp, 521)
                        if Duel.GetMatchingGroupCount(Card.IsType, ttp, LOCATION_DECK, 0, nil, TYPE_PENDULUM) > 1 and
                            Duel.SelectYesNo(ttp, aux.Stringid(827, 1)) then
                            Duel.Hint(HINT_SELECTMSG, ttp, HINTMSG_TARGET)
                            local destinytc = Duel.SelectMatchingCard(ttp, Card.IsType, ttp, LOCATION_DECK, 0, 1, 2, nil, TYPE_PENDULUM)
                            if not destinytc then return end
                            Duel.ShuffleDeck(ttp)
                            local tac2 = Duel.GetDecktopGroup(ttp, #destinytc)
                            if #tac2<1 then return end
                            aux.SwapEntity(destinytc, tac2)
                            Duel.Hint(HINT_MESSAGE, 1 - ttp, aux.Stringid(827, 1))
                        end
                    end
                    if opval[op] == 11 then
                       Duel.RegisterFlagEffect(ttp, 784, 0, 0, 1, Duel.GetLP(ttp))
                       tt = Duel.CreateToken(ttp, 14)
                       Duel.Hint(HINT_SKILL, ttp, 14)
                    end
                    if opval[op] == 12 then
                        Duel.RegisterFlagEffect(ttp, 10000004, 0, 0, 1)
                        tt = Duel.CreateToken(ttp, 25)
                        Duel.Hint(HINT_SKILL, ttp, 25)
                    end
                    if opval[op] == 13 then
                        Duel.RegisterFlagEffect(ttp, 107, 0, 0, 1)
                        tt = Duel.CreateToken(ttp, 107)
                        Duel.Hint(HINT_SKILL, ttp, 107)
                    end
                    if opval[op] == 14 then
                        Duel.RegisterFlagEffect(ttp, 108, 0, 0, 1)
                        tt = Duel.CreateToken(ttp, 108)
                        Duel.Hint(HINT_SKILL,ttp, 108)
                    end
                end
                if counts[ttp]~=1 then
                    Duel.TagSwap(ttp) --loop to other players deck
                end
            end
        end
        e:Reset()
    end

    function DestinyDraw.xyzsumcon(e, tp, eg, ep, ev, re, r, rp)
        return eg:IsExists(DestinyDraw.xyzsumfilter, 1, nil)
    end
    function DestinyDraw.xyzsumfilter(c)
        return c:IsSetCard(0x48)
    end
    function DestinyDraw.xyzsumop(e, tp, eg, ep, ev, re, r, rp)
        if not eg:IsExists(DestinyDraw.xyzsumfilter, 1, nil) then
            return
        end
        local g = eg:Filter(DestinyDraw.xyzsumfilter, nil)
        local tc = g:GetFirst()
        while tc do
            -- cannot destroyed
            local e0 = Effect.CreateEffect(tc)
            e0:SetType(EFFECT_TYPE_SINGLE)
            e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
            e0:SetValue(DestinyDraw.indes)
            tc:RegisterEffect(e0, true)
            tc = g:GetNext()
        end
    end
    function DestinyDraw.indes(e, c)
        return not e:GetHandler():GetBattleTarget():IsSetCard(0x48)
    end

    function DestinyDraw.removecon(e, tp, eg, ep, ev, re, r, rp)
        return eg:IsExists(Card.IsCode, 1, nil, 946)
    end
    function DestinyDraw.removeop(e, tp, eg, ep, ev, re, r, rp)
        if not eg:IsExists(Card.IsCode, 1, nil, 946) then
            return
        end
        local g = eg:Filter(Card.IsCode, nil, 946)
        Duel.SendtoDeck(g, 0, -2, REASON_RULE)
    end

    function DestinyDraw.DDfiler(c)
        local no = c.xyz_number
        return no and no >= 101 and no <= 107
        and c:IsSetCard(0x1048)
    end
    function DestinyDraw.DDfiler2(c)
        local no = c.xyz_number
        return no and no >= 101 and no <= 107
        and not c:IsSetCard(0x1048)
    end

    -- Cartoon World
    function DestinyDraw.DTMfiler(c)
        return c:IsSetCard(0x62) and c:IsType(TYPE_MONSTER)
    end

    -- Syncho
    function DestinyDraw.RDSfiler(c)
        return c:IsCode(44508094) or c:IsCode(70902743)
    end
    function DestinyDraw.RRDSfiler(c)
        return c:IsCode(2403771)
    end
    function DestinyDraw.RRDSfiler2(c, qt)
        return c:IsType(TYPE_TUNER) and c:GetLevel() == qt
    end

    -- Cyberse
    function DestinyDraw.linkcyber(c)
        return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER)
    end

    --phantom
    function DestinyDraw.phantom(c)
        return c:IsRace(RACE_FIEND) and not c:IsCode(69890967) and c:IsType(TYPE_MONSTER)
    end
    
    finishsetup()
end

-- local isRank = Card.IsRank
-- function Card.IsRank(c, rk)
--     local tp = c:GetControler()
--     if (Duel.GetFlagEffect(tp, 90999980) ~= 0 or Duel.GetFlagEffect(tp, 91999980) ~= 0)
--     and Duel.IsExistingTarget(DestinyDraw.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
--     and (c:IsOriginalCode(27) or c:IsOriginalCode(28)) and c:IsLocation(LOCATION_EXTRA) then
--         return true
--     elseif Duel.GetFlagEffect(tp, 388) ~= 0
--     and Duel.IsExistingTarget(DestinyDraw.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp)
--     and c:IsOriginalCode(36) and c:IsLocation(LOCATION_EXTRA) then
--         return true
--     else
--         return isRank(c, rk)
--     end
-- end
function DestinyDraw.filter1(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c)))
    and c:IsFaceup()
    and not c:IsSetCard(0x1048) and not c:IsSetCard(0x1073) and not c:IsSetCard(0x2048) and not c:IsSetCard(0x2073)
    and (c:GetRank()>0 or c:IsStatus(STATUS_NO_LEVEL)) and c:GetRank()<13
    and c:GetRank() == c:GetOriginalRank()
    and c:GetRealCode()==0
end

-- local matchg = Duel.GetMatchingGroup
-- function Duel.GetMatchingGroup(f, tp, s, o, ex, ...)
--     if tp == nil then
--         tp = 0
--     end
--     if f == nil then
--         f = aux.TRUE
--     end
--     local nf =f
--     local mattg = matchg(nf, tp, s, o, ex, ...)
--     if not mattg then
-- 		return nil
--     end

--     local re = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT)
--     local rp = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_PLAYER)
--     local gcount = 0
--     if bit.band(s, LOCATION_EXTRA) ~= 0 and s ~= 0xff 
--     and (re == nil or (re and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON))) and rp==tp
--     and (Duel.GetFlagEffect(tp, 388) ~= 0 or Duel.GetFlagEffect(tp, 90999980) ~= 0 or Duel.GetFlagEffect(tp, 91999980) ~= 0)
--     and (#mattg < 1 or Duel.SelectYesNo(tp, aux.Stringid(826, 12))) then
--         local sp,tg,count=Duel.GetOperationInfo(0, CATEGORY_SPECIAL_SUMMON)
--         if re == nil then count = 1 end
--         local exa=Group.CreateGroup()
--         for i = 1, count do
--             if i==1 or Duel.SelectYesNo(tp, aux.Stringid(826, 12)) then
--                 local announce_filter={TYPE_FUSION + TYPE_SYNCHRO + TYPE_XYZ + TYPE_LINK, OPCODE_ISTYPE}
--                 for _, val in ipairs(Announce[tp]) do
--                     table.insert(announce_filter, val)
--                     table.insert(announce_filter, OPCODE_ISCODE)
--                     table.insert(announce_filter, OPCODE_NOT)
--                     table.insert(announce_filter, OPCODE_AND)
--                 end
--                 table.insert(announce_filter, SCOPE_CUSTOM)
--                 table.insert(announce_filter, OPCODE_ISOTYPE)
--                 table.insert(announce_filter, OPCODE_NOT)
--                 table.insert(announce_filter, OPCODE_AND)
--                 table.insert(announce_filter, OPCODE_ALLOW_ALIASES)
--                 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE) 
--                 local code = Duel.AnnounceCard(tp, table.unpack(announce_filter))
--                 local token= Duel.CreateToken(tp, code)
--                 Duel.SendtoDeck(token, tp, 0, REASON_RULE)
--                 if aux.AIchk[tp] == 0 then
--                     local chk = 0
--                     for index, value in ipairs(Announce[tp]) do
--                         if value == code and not (code == 27 or code == 28 or code == 29 or code == 36) then
--                             chk = 1
--                             goto continue
--                         end
--                     end
--                     if chk == 0 then table.insert(Announce[tp], code) end
--                 end
--                 token:SetEntityCode(code, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
--                 if nf(token, ...) then
--                     exa:AddCard(token)           
--                 end
--                 gcount = gcount + 1
--                 ::continue::
--             end
--         end    
--         local exg2 = mattg
--         if gcount < count then
--             local extra = exg2:Select(tp, 1, count - gcount, false)
--             exa:Merge(extra)
--         end
--         return exa
--     end
--     return mattg
-- end
-- local exist = Duel.IsExistingMatchingCard
-- function Duel.IsExistingMatchingCard(f, tp, s, o, count, ex, ...)
--     if tp == nil then
--         tp = 0
--     end
--     if f == nil then
--         f = aux.TRUE
--     end
--     if bit.band(s, LOCATION_EXTRA) ~= 0 and s ~= 0xff 
--     and (Duel.GetFlagEffect(tp, 388) ~= 0 or Duel.GetFlagEffect(tp, 90999980) ~= 0 or Duel.GetFlagEffect(tp, 91999980) ~= 0) then
--         return true
--     end
--     return exist(f, tp, s, o, count, ex, ...)
-- end
-- local existt = Duel.IsExistingTarget
-- function Duel.IsExistingTarget(f, tp, s, o, count, ex, ...)
--     if tp == nil then
--         tp = 0
--     end
--     if f == nil then
--         f = aux.TRUE
--     end
--     if bit.band(s, LOCATION_EXTRA) ~= 0 and s ~= 0xff 
--     and (Duel.GetFlagEffect(tp, 388) ~= 0 or Duel.GetFlagEffect(tp, 90999980) ~= 0 or Duel.GetFlagEffect(tp, 91999980) ~= 0) then
--         return true
--     end
--     return existt(f, tp, s, o, count, ex, ...)
-- end
local selectc = Duel.SelectMatchingCard
function Duel.SelectMatchingCard(sel_player, f, tp, s, o, mint, maxt, cancel, ex, ...)
    if tp == nil then tp = 0 end
    if f == nil then f = aux.TRUE end
    local params = {ex,...}
    if cancel == nil or type(cancel) == "Card" or type(cancel) == "Group" then
        ex = cancel
        cancel = false
    else 
        params = {...}
    end
    if tp == nil then tp = 0 end
    local exa = Group.CreateGroup()
    -- local exa2 = Group.CreateGroup()
    local g = Duel.GetMatchingGroup(f, tp, s, o, ex, table.unpack(params))
    local gcount = 0
    local re = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT)
    local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
    local tgc
    if tg and #tg == 1 then
        tgc = tg:GetFirst()
    end
    local xg = g:Filter(function(c) return ((c:IsOriginalCode(27) or c:IsOriginalCode(28) or c:IsOriginalCode(29) or c:IsOriginalCode(36)) and c:IsLocation(LOCATION_EXTRA)) end, nil)
    g:Sub(xg)

    if (Duel.GetFlagEffect(tp, 90999980) ~= 0 or Duel.GetFlagEffect(tp, 91999980) ~= 0 or Duel.GetFlagEffect(tp, 388) ~= 0)
    and bit.band(s, LOCATION_EXTRA) ~= 0 and sel_player == tp
    and mint == maxt and maxt == 1
    and re and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
    and tg and #tg == 1 and tgc:IsType(TYPE_XYZ)
    and tgc:IsControler(tp) and tgc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and tgc:IsFaceup()
    and not tgc:IsSetCard(0x1048) and not tgc:IsSetCard(0x1073) and not tgc:IsSetCard(0x2048) and not tgc:IsSetCard(0x2073)
    and (tgc:GetRank() > 0 or tgc:IsStatus(STATUS_NO_LEVEL)) and tgc:GetRank() < 13
    and tgc:GetRank() == tgc:GetOriginalRank()
    and tgc:GetRealCode()==0 then
        local ocode = tgc:GetOriginalCode()
        if Duel.GetFlagEffect(tp, 90999980) ~= 0 or Duel.GetFlagEffect(tp, 91999980) ~= 0 then
            local matgc = nil
            local token = nil
            local tokencode = 0
            if not tgc.xyz_number and not aux.cxlist[tgc:GetOriginalAlias()] then
                token = Duel.CreateToken(tp, 27)
                tokencode = 27
                tokenset = 0x1073
            elseif tgc.xyz_number and not aux.notoclist[tgc.xyz_number] and not tgc:IsCode(4997565) then
                token = Duel.CreateToken(tp, 28)
                tokencode = 28
                tokenset = 0xcf
            end
            if token then
                Duel.SendtoDeck(token, tp, 0, REASON_RULE)
                local ss=aux.mix_twosetcodes(tgc, token)
                token:SetEntityCode(ocode, nil, ss, nil, tgc:GetOriginalRank() + 1, nil, nil, tgc:GetTextAttack() + 500, tgc:GetTextDefense() + 1000, nil, nil, nil, false, tokencode, ocode, tokencode)
                if f(token, table.unpack(params)) then
                    g:AddCard(token)
                end
            end
            local matg = g:Select(tp,1,1,ex)
            matgc = matg:GetFirst()
            exa:AddCard(matgc)
            if token and matgc~=token then Duel.SendtoDeck(token,tp,-2,REASON_RULE) end
        -- for i = 1, maxt do
        --     if gcount >= mint and not Duel.SelectYesNo(sel_player, aux.Stringid(826, 12)) then
        --         break
        --     end
        --     if #g < 1 or
        --         (gcount < mint and Duel.SelectYesNo(sel_player, aux.Stringid(826, 12)) or gcount >= mint) then
            if matgc then
                local efftype={0,0,0} --0:Self Trigger, 1:Continuous, 2:Field Trigger
                local effcode={-1,-1,-1}
                local effop={0,0,0}
                local lv=tgc:GetOriginalRank()
                local otcode=matgc:GetOriginalCode()
                local effno=2
                if lv>8 then effno=3 
                elseif lv>11 then effno=4 end
                local lastefftype=0
                local effevent={EVENT_BE_BATTLE_TARGET,EVENT_ATTACK_ANNOUNCE,EVENT_SPSUMMON_SUCCESS,EVENT_DESTROYED,EVENT_BATTLE_DESTROYING,EFFECT_TYPE_IGNITION,EVENT_CHAINING}
                local fieldeffevent={EVENT_BE_BATTLE_TARGET,EVENT_ATTACK_ANNOUNCE,EVENT_SPSUMMON_SUCCESS,EVENT_DRAW}
                local hascodetable=false
                local hascodetable2=false
                for k,tab in pairs(_G["c" .. otcode]) do
                    if k=="cefflist" then
                        hascodetable=true
                        if type(tab)=="table" then
                            for k2,tab2 in pairs(tab) do
                                if k2==ocode then
                                    hascodetable2=true
                                end
                            end
                        end
                    end
                end
                if not hascodetable then
                    matgc.__index["cefflist"]={}
                end
                if not hascodetable2 then
                    matgc.__index["cefflist"][ocode]={}
                    for i=1,effno do
                        matgc.__index["cefflist"][ocode][i]={}
                    end
                end
                for i=1,effno do
                    if hascodetable then
                        efftype[i],effcode[i],effop[i]=table.unpack(matgc.__index["cefflist"][ocode][i])
                    else
                        local typeno=Duel.GetRandomNumber(0,2)
                        if i>1 and lastefftype~=1 then
                            typeno=1
                        end
                        if typeno==2 then 
                            local eventno=Duel.GetRandomNumber(1,#fieldeffevent)
                            effcode[i]=fieldeffevent[eventno]
                        end
                        if typeno==0 then
                            local eventno=Duel.GetRandomNumber(1,#effevent)
                            effcode[i]=effevent[eventno]
                        end
                        efftype[i]=typeno
                        effop[i]=Duel.GetRandomNumber(0,5)
                        lastefftype=efftype[i]
                        matgc.__index["cefflist"][ocode][i]={efftype[i],effcode[i],effop[i]}
                    end
                end
                efftype[1]=0
                effcode[1]=EVENT_CHAINING
                efftype[2]=1
                effop[2]=1
                for i=1,effno do
                    local noeffect=false
                    local prop=EFFECT_FLAG_CLIENT_HINT
                    local e1=Effect.CreateEffect(matgc)
                    if efftype[i]==0 then
                        if effcode[i]==EVENT_CHAINING then
                            prop=prop|EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL
                            e1:SetType(EFFECT_TYPE_QUICK_O)
                            e1:SetCode(EVENT_CHAINING)
                            e1:SetRange(LOCATION_MZONE)
                            e1:SetDescription(aux.Stringid(42,11),true)
                            e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
                            e1:SetCondition(DestinyDraw.discon)
                            e1:SetTarget(DestinyDraw.distg)
                            e1:SetOperation(DestinyDraw.disop)
                        else
                            local desc={}
                            if effcode[i]==EVENT_BE_BATTLE_TARGET then 
                                desc={aux.Stringid(id,5),true}
                            elseif effcode[i]==EVENT_ATTACK_ANNOUNCE then 
                                desc={aux.Stringid(id,4),true}
                            elseif effcode[i]==EVENT_SPSUMMON_SUCCESS then 
                                desc={aux.Stringid(id,6),true}
                            elseif effcode[i]==EVENT_DESTROYED then 
                                desc={aux.Stringid(id,7),true}
                            elseif effcode[i]==EVENT_BATTLE_DESTROYING then 
                                desc={aux.Stringid(id,13),true}
                            elseif effcode[i]==EFFECT_TYPE_IGNITION then 
                                desc={aux.Stringid(id,8),true}
                            end
                            if effcode[i]~=EFFECT_TYPE_IGNITION then 
                                e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
                            end
                            e1:SetCode(effcode[i])
                            if effop[i]==0 then
                                e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
                                e1:SetTarget(DestinyDraw.desatg)
                                e1:SetOperation(DestinyDraw.desaop)
                                table.insert(desc,aux.Stringid(42,14))
                            else
                                prop,desc=DestinyDraw.wkeffs(effop[i],e1,prop,desc)
                            end
                            e1:SetDescription(table.unpack(desc))
                        end
                        e1:SetCost(DestinyDraw.cost)
                    elseif efftype[i]==1 then
                        e1:SetType(EFFECT_TYPE_SINGLE)
                        e1:SetRange(LOCATION_MZONE)
                        prop=prop|EFFECT_FLAG_SINGLE_RANGE
                        if effop[i]>0 then
                            if matgc:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT) then
                                noeffect=true
                            end
                            e1:SetDescription(aux.Stringid(42,4),true)
                            e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
                            e1:SetValue(1)
                        elseif effop[i]==1 then
                            if matgc:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT) then
                                noeffect=true
                            end
                            e1:SetDescription(aux.Stringid(42,1),true)
                            e1:SetCode(EFFECT_PIERCE)
                        elseif effop[i]==2 then
                            if matgc:IsHasEffect(EFFECT_IMMUNE_EFFECT) then
                                noeffect=true
                            end
                            e1:SetDescription(aux.Stringid(42,3),true)
                            e1:SetCode(EFFECT_IMMUNE_EFFECT)
                            e1:SetValue(DestinyDraw.immval)
                        elseif effop[i]==3 then
                            if matgc:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET) then
                                noeffect=true
                            end
                            e1:SetDescription(aux.Stringid(42,0),true)
                            e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
                            e1:SetValue(1)
                        else
                            if matgc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
                                noeffect=true
                            end
                            e1:SetDescription(aux.Stringid(42,2),true)
                            e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
                            e1:SetValue(1)
                        end
                    else
                        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
                        e1:SetRange(LOCATION_MZONE)
                        e1:SetCode(effcode[i])
                        local desc={}
                        if effcode[i]==EVENT_BE_BATTLE_TARGET then 
                            desc={aux.Stringid(id,10),true}
                            e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==tp end)
                        elseif effcode[i]==EVENT_ATTACK_ANNOUNCE then 
                            desc={aux.Stringid(id,9),true}
                            e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==tp end)
                        elseif effcode[i]==EVENT_SPSUMMON_SUCCESS then 
                            desc={aux.Stringid(id,11),true}
                            e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==tp end)
                        elseif effcode[i]==EVENT_DRAW then
                            if effop[i]<2 then
                                desc={aux.Stringid(id,3),true}
                                e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep~=tp end)
                            else
                                desc={aux.Stringid(id,12),true}
                                e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==tp end)
                            end
                        end
                        prop,desc=DestinyDraw.wkeffs(effop[i],e1,prop,desc)
                        e1:SetDescription(table.unpack(desc))
                    end
                    e1:SetProperty(prop)
                    if not noeffect then
                        matgc:RegisterEffect(e1)
                    else
                        e1:Reset()
                    end
                end
            end
        elseif Duel.GetFlagEffect(tp, 388) ~= 0 then
            if tgc.xyz_number and not (tgc.xyz_number == 39 or tgc.xyz_number == 93 or tgc.xyz_number == 0) then
                local token = Duel.CreateToken(tp, 36)
                Duel.SendtoDeck(token, nil, 0, REASON_RULE)
                local ss=aux.mix_twosetcodes(tgc, token)
                token:SetEntityCode(ocode, nil, ss, nil, tgc:GetOriginalRank() + 1, nil, nil, nil, nil, nil, nil, nil, false, 36, 36, 36)
                if f(token, table.unpack(params)) then
                    g:AddCard(token)
                end
                local matg = g:Select(tp,1,1,ex)
                matgc = matg:GetFirst()
                exa:AddCard(matgc)
                if token and matgc~=token then Duel.SendtoDeck(token,tp,-2,REASON_RULE) end
            end
        end
                -- end
                -- local announce_filter={TYPE_FUSION + TYPE_SYNCHRO + TYPE_XYZ + TYPE_LINK, OPCODE_ISTYPE}
                -- for _, val in ipairs(Announce[sel_player]) do
                --     table.insert(announce_filter, val)
                --     table.insert(announce_filter, OPCODE_ISCODE)
                --     table.insert(announce_filter, OPCODE_NOT)
                --     table.insert(announce_filter, OPCODE_AND)
                -- end
                -- table.insert(announce_filter, SCOPE_CUSTOM)
                -- table.insert(announce_filter, OPCODE_ISOTYPE)
                -- table.insert(announce_filter, OPCODE_NOT)
                -- table.insert(announce_filter, OPCODE_AND)
                -- table.insert(announce_filter, OPCODE_ALLOW_ALIASES)
                -- Duel.Hint(HINT_SELECTMSG,sel_player,HINTMSG_CODE) 
                -- local code = Duel.AnnounceCard(sel_player, table.unpack(announce_filter))
                -- local token = Duel.CreateToken(sel_player, code)
                -- Duel.SendtoDeck(token, sel_player, 0, REASON_RULE)
                -- if aux.AIchk[sel_player] == 0 then
                --     local chk = 0
                --     for index, value in ipairs(Announce[sel_player]) do
                --         if value == code and not (code == 27 or code == 28 or code == 29 or code == 36) then
                --             chk = 1
                --             goto continue
                --         end
                --     end
                --     if chk == 0 then table.insert(Announce[sel_player], code) end
                -- end
                -- if code == 27 or code == 28 or code == 29 or code == 36 then
                --     aux.xyzchanger(code, token)
                -- end
                -- if f(token, table.unpack(params)) then
                --     exa:Merge(Group.FromCards(token))
                -- else
                --     exa2:Merge(Group.FromCards(token))
                -- end
            -- else
            --     if g:GetCount() >0 then
            --         local bg = g:Select(tp, 1, 1, false)
            --         exa:Merge(bg)
            --         g:Sub(bg)
            --     end
            -- end
            -- ::continue::
            -- gcount = gcount + 1
        -- end
    end
    -- local minct = mint - gcount
    -- if minct < 1 then
    --     minct = 1
    -- end
    -- if maxt - gcount < 1 then
    --     return exa
    -- end
    -- local fg = selectc(sel_player, function(c) return f(c, table.unpack(params)) and not c:IsCode(827) and not c:IsCode(946) and not exa:IsContains(c) and not exa2:IsContains(c) end, tp, s, o, minct, maxt - gcount, ex)
    -- fg:Merge(exa)
    if #exa > 0 then return exa
    else return 
        selectc(sel_player, function(c)
            return f(c, table.unpack(params)) and not c:IsCode(27) and not c:IsCode(28) and not c:IsCode(29) and not c:IsCode(36)
        end, tp, s, o, mint, maxt, cancel, ex) end
end
function DestinyDraw.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function DestinyDraw.wkeffs(effop,e1,prop,desc)
    if effop==0 then
        prop=prop|EFFECT_FLAG_CARD_TARGET
        e1:SetCategory(CATEGORY_REMOVE)
        e1:SetTarget(DestinyDraw.starget1)
        e1:SetOperation(DestinyDraw.soperation1)
        table.insert(desc,aux.Stringid(42,6))
    elseif effop==1 then
        prop=prop|EFFECT_FLAG_CARD_TARGET
        e1:SetCategory(CATEGORY_DESTROY)
        e1:SetTarget(DestinyDraw.starget2)
        e1:SetOperation(DestinyDraw.soperation2)
        table.insert(desc,aux.Stringid(42,7))
    elseif effop==2 then
        prop=prop|EFFECT_FLAG_CARD_TARGET
        e1:SetCategory(CATEGORY_DISABLE)
        e1:SetTarget(DestinyDraw.starget3)
        e1:SetOperation(DestinyDraw.soperation3)
        table.insert(desc,aux.Stringid(42,8))
    elseif effop==3 then
        prop=prop|EFFECT_FLAG_CARD_TARGET
        e1:SetCategory(CATEGORY_ATKCHANGE)
        e1:SetTarget(DestinyDraw.starget4)
        e1:SetOperation(DestinyDraw.soperation4)
        table.insert(desc,aux.Stringid(42,9))
    elseif effop==4 then
        prop=prop|EFFECT_FLAG_PLAYER_TARGET
        e1:SetCategory(CATEGORY_DAMAGE)
        e1:SetTarget(DestinyDraw.damtg)
        e1:SetOperation(DestinyDraw.damop)
        table.insert(desc,aux.Stringid(42,15))
    elseif effop==5 then
        prop=prop|EFFECT_FLAG_PLAYER_TARGET
        e1:SetCategory(CATEGORY_DRAW)
        e1:SetTarget(DestinyDraw.drtg3)
        e1:SetOperation(DestinyDraw.drop3)
        table.insert(desc,aux.Stringid(42,5))
    end
    return prop,desc
end
function DestinyDraw.desatg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function DestinyDraw.desaop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function DestinyDraw.sfilter1(c)
	return c:IsAbleToRemove()
end
function DestinyDraw.starget1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and DestinyDraw.sfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(DestinyDraw.sfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,DestinyDraw.sfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function DestinyDraw.soperation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,nil,REASON_EFFECT)
	end
end

function DestinyDraw.sfilter2(c)
	return c:IsDestructable()
end
function DestinyDraw.starget2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and DestinyDraw.sfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(DestinyDraw.sfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,DestinyDraw.sfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function DestinyDraw.soperation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function DestinyDraw.starget3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and DestinyDraw.wkenfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(DestinyDraw.wkenfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,DestinyDraw.wkenfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function DestinyDraw.soperation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	end
end

function DestinyDraw.sfilter4(c)
	return c:GetAttack()>0 and c:IsFaceup()
end
function DestinyDraw.starget4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and DestinyDraw.sfilter4(chkc) end
	if chk==0 then return Duel.IsExistingTarget(DestinyDraw.sfilter4,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,DestinyDraw.sfilter4,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function DestinyDraw.soperation4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
	end
end

function DestinyDraw.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function DestinyDraw.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function DestinyDraw.disop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0
		and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e:GetHandler():RegisterEffect(e1)
	end
end

function DestinyDraw.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(Card.IsOnField,1,nil) and Duel.IsChainNegatable(ev)
end
function DestinyDraw.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function DestinyDraw.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function DestinyDraw.immval(e,te)
	local tc=te:GetOwner()
	local c=e:GetHandler()
	return c~=tc
end

function DestinyDraw.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function DestinyDraw.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function DestinyDraw.drtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function DestinyDraw.drop3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
-- local selectt = Duel.SelectTarget
-- function Duel.SelectTarget(sel_player, f, tp, s, o, mint, maxt, cancel, ex, ...)
--     if tp == nil then
--         tp = 0
--     end
--     if f == nil then
--         f = aux.TRUE
--     end
--     local params={ex,...}
--     if cancel==nil or type(cancel)=="Card" or type(cancel)=="Group" then
--         ex=cancel
--         cancel=false
--     else params={...}
--     end
--     local exa = Group.CreateGroup()
--     local exa2 = Group.CreateGroup()
--     local g = matchg(function(c) return f(c, table.unpack(params)) and c:IsCanBeEffectTarget() end, tp, s, o, ex)
--     local gcount = 0
--     local re = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT)
--     if bit.band(s, LOCATION_EXTRA) ~= 0 and sel_player == tp 
--     and re and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
--     and (Duel.GetFlagEffect(tp, 388) ~= 0 or Duel.GetFlagEffect(tp, 90999980) ~= 0 or Duel.GetFlagEffect(tp, 91999980) ~= 0) then
--         for i = 1, maxt do
--             if gcount >= mint and not Duel.SelectYesNo(sel_player, aux.Stringid(826, 12)) then
--                 break
--             end
--             if #g < 1 or 
--                 (gcount < mint and Duel.SelectYesNo(sel_player, aux.Stringid(826, 12)) or gcount >= mint) then
--                 local announce_filter={TYPE_FUSION + TYPE_SYNCHRO + TYPE_XYZ + TYPE_LINK, OPCODE_ISTYPE}
--                 for _, val in ipairs(Announce[sel_player]) do
--                     table.insert(announce_filter, val)
--                     table.insert(announce_filter, OPCODE_ISCODE)
--                     table.insert(announce_filter, OPCODE_NOT)
--                     table.insert(announce_filter, OPCODE_AND)
--                 end
--                 table.insert(announce_filter, SCOPE_CUSTOM)
--                 table.insert(announce_filter, OPCODE_ISOTYPE)
--                 table.insert(announce_filter, OPCODE_NOT)
--                 table.insert(announce_filter, OPCODE_AND)
--                 table.insert(announce_filter, OPCODE_ALLOW_ALIASES)
--                 Duel.Hint(HINT_SELECTMSG,sel_player,HINTMSG_CODE) 
--                 local code = Duel.AnnounceCard(sel_player, table.unpack(announce_filter))
--                 local token = Duel.CreateToken(sel_player, code)
--                 Duel.SendtoDeck(token, sel_player, 0, REASON_RULE)
--                 if aux.AIchk[sel_player] == 0 then
--                     local chk = 0
--                     for index, value in ipairs(Announce[sel_player]) do
--                         if value == code and not (code == 27 or code == 28 or code == 29 or code == 36) then
--                             chk = 1
--                             goto continue
--                         end
--                     end
--                     if chk == 0 then table.insert(Announce[sel_player], code) end
--                 end
--                 if code == 27 or code == 28 or code == 29 or code == 36 then
--                     aux.xyzchanger(code, token)
--                 end
--                 if f(token,table.unpack(params)) then
--                     exa:Merge(Group.FromCards(token))
--                 else
--                     exa2:Merge(Group.FromCards(token))
--                 end
--             else
--                 if g:GetCount() >0 then
--                     local bg = g:Select(tp, 1, 1, false)
--                     exa:Merge(bg)
--                     g:Sub(bg)
--                 end
--             end
--             gcount = gcount + 1
--             ::continue::
--         end
--     end
--     local minct = mint - gcount
--     if minct < 1 then
--         minct = 1
--     end
--     if maxt - gcount < 1 then
--         return exa
--     end
--     local fg = selectt(sel_player, function(c) return f(c, table.unpack(params)) and not c:IsCode(827) and not c:IsCode(946) and not exa:IsContains(c) and not exa2:IsContains(c) end, tp, s, o, minct, maxt - gcount, ex)
--     fg:Merge(exa)
--     return fg
-- end

----------skill----------
local fieldskill=Auxiliary.AddFieldSkillProcedure
function Auxiliary.AddFieldSkillProcedure(c,coverNum,drawless)
	if c.skill_type==nil then
		local code=c:GetOriginalCode()
		local mt=c:GetMetatable()
		mt.skill_type=0
		mt.drawless=drawless
	end
    return fieldskill(c,coverNum,drawless)
end
local continuousskill=Auxiliary.AddContinuousSkillProcedure
function Auxiliary.AddContinuousSkillProcedure(c,coverNum,drawless,flip)
	if c.skill_type==nil then
		local code=c:GetOriginalCode()
		local mt=c:GetMetatable()
		mt.skill_type=1
		mt.drawless=drawless
		mt.flip=flip
	end
    return continuousskill(c,coverNum,drawless,flip)
end
function Auxiliary.AddSkillProcedure(c,coverNum,drawless,skillcon,skillop,countlimit)
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(Auxiliary.SetSkillOp(coverNum,skillcon,skillop,countlimit,EVENT_FREE_CHAIN))
	c:RegisterEffect(e1)
	Auxiliary.AddDrawless(c,drawless)
	
	if c.skill_type==nil then
		local code=c:GetOriginalCode()
		local mt=c:GetMetatable()
		mt.skill_type=2
		mt.coverNum=coverNum
		mt.drawless=drawless
		mt.skillcon=skillcon
		mt.skillop=skillop
		mt.countlimit=countlimit
	end
	local mt=c:GetMetatable()
		if mt.startopex == nil then
	    mt.startopex = {e1}
    else
        table.insert(mt.startopex, e1)
    end
end
function Auxiliary.AddPreDrawSkillProcedure(c,coverNum,drawless,skillcon,skillop,countlimit)
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(Auxiliary.SetSkillOp(coverNum,skillcon,skillop,countlimit,EVENT_PREDRAW))
	c:RegisterEffect(e1)
	Auxiliary.AddDrawless(c,drawless)
	
	if c.coverNum2==nil then
		local code=c:GetOriginalCode()
		local mt=c:GetMetatable()
		mt.coverNum2=coverNum
		mt.drawless2=drawless
		mt.skillcon2=skillcon
		mt.skillop2=skillop
		mt.countlimit2=countlimit
	end
	local mt=c:GetMetatable()
		if mt.startopex == nil then
	    mt.startopex = {e1}
    else
        table.insert(mt.startopex, e1)
    end
end
function Auxiliary.AddVrainsSkillProcedure(c,skillcon,skillop,efftype)
	efftype=efftype or EVENT_FREE_CHAIN
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetOperation(Auxiliary.SetVrainsSkillOp(skillcon,skillop,efftype))
	c:RegisterEffect(e1)
	
	if c.skill_type==nil then
		local code=c:GetOriginalCode()
		local mt=c:GetMetatable()
		mt.skill_type=3
		mt.skillcon=skillcon
		mt.skillop=skillop
		mt.efftype=efftype
	end
	local mt=c:GetMetatable()
	if mt.startopex == nil then
	    mt.startopex = {e1}
    else
        table.insert(mt.startopex, e1)
    end
end