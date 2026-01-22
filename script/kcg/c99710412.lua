--娱乐模式
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=99710411
if self_code then id=self_code end
if not ModeGame_1 then
		ModeGame_1={}
		local function finishsetup()
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_STARTUP)
		e0:SetOperation(ModeGame_1.stop)
		Duel.RegisterEffect(e0,0)
	end

    pack={}
		pack[1]={
			57308711,61257789,34492631,41705642,61864793,88559132,58242947,511001435,51987571,511000737,511002021,94538053,511010531,70630741,78922939,31281980,59965151,23535429,511002881,88032368,56410040,34257001,68120130,79337169,97385276,20797524,17932494,23571046,53855409,66288028,44236692,44935634,83392426,810000050,810000050,60741115,28859794,511001459,77700347,36643046,511013018,71353388,36472900,511018002,89235196,27450400,92676637,17841097,45358284,96146814,511002807,18964575,60187739,511002883,511010533
		}
        pack[2]={
			511002860,71971554,511002755,52840598,14943837,511001639,63977008,11287364,511002910,511002136,96182448,511015120,511600376,67270095,511000743,16638212,21159309,25652655,56897896,97268402,511002135
		}
        pack[3]={
			14017402,371,511000774,513000031,7841112,513000012,511001658,2322421,74860293,44508094,18013090,511027027,511001956,42810973,511015124,46195773,511001982,53981499,511001516,511010534,511001517,511600105,511009416,511021003,511001983,29071332,511001963
		}
        pack[4]={
			43422537,72767833,511002846,2295440,511013016,511002844,52128900,511600013,51630558,511010537,511000754,26194151,32663969,79068663,6178850,94303232,511010532,73048641,49267971,75652080,511000749
		}
        pack[5]={
			5609226,14507213,16674846,17521642,21636650,24268052,24545464,30123142,36280194,42079445,47264717,53656677,55465441,62878208,67630339,73729209,92450185,94484482,94634433,96700602,98427577,511000623,511002519,511002520,511002552,511002879,511002911,511004111,511010535,511018015,810000006,810000057,34149830,79205581,98273947,513000056,511013017
		}


	function LoadDeck(tp,Size,type)
		if Size>0 then
            local groups={}
            local chksame={} --avoid same code <3, each index represents same index of pack[type]
            local loc=LOCATION_DECK
            if type==3 then loc=LOCATION_EXTRA end
            local packsize=#pack[type]
            if Size>packsize then Size=packsize end
            local loopsize=0
            for i=1,packsize do table.insert(chksame,0) end --same size as pack[type], each value represents count of code randomly picked
            while Size>0 do
                local randno=Duel.GetRandomNumber(1,packsize) --random pick an index of #pack[type]
                if chksame[randno]<1 then
                    chksame[randno]=1
                    table.insert(groups,randno)
                    Size=Size-1
                end
                loopsize=loopsize+1
                if loopsize>=packsize then break end
            end
            for _,v in ipairs(groups) do
                local code=pack[type][v]
                Debug.AddCard(code,tp,tp,loc,1,POS_FACEDOWN_DEFENSE)
            end
		end
	end
    function AddCardSpecial(tp,team,codelist,addcard,loc,addloc,codelist2,loc2)
        if Duel.IsExistingMatchingCard(Card.IsCode,tp,loc,0,1,nil,table.unpack(codelist)) 
        and not Duel.IsExistingMatchingCard(Card.IsCode,tp,addloc,0,1,nil,addcard)
        and (not codelist2 or Duel.IsExistingMatchingCard(Card.IsCode,tp,loc2,0,1,nil,table.unpack(codelist2))) then
            Debug.AddCard(addcard,tp,tp,addloc,1,POS_FACEDOWN_DEFENSE)
        end
    end
	function ModeGame_1.stop(e,tp,eg,ep,ev,re,r,rp)
		for _,card in ipairs(selfs) do
            Duel.DisableShuffleCheck()
			Duel.SendtoDeck(card,0,-2,REASON_RULE) --exile this card
		end

        local counts={}
		counts[0]=Duel.GetPlayersCount(0)
		counts[1]=Duel.GetPlayersCount(1)

		local z,o=tp,1-tp
		for p=z,o do
            if Duel.GetMatchingGroupCount(Card.IsCode, p, LOCATION_EXTRA, 0, nil, 111) > 0 then
				aux.AIchk[p]=1
			end
			for team=1,counts[p] do
                if aux.AIchk[p]~=1 and Duel.GetFieldGroupCount(p,LOCATION_DECK,0)<1 then
				-- Duel.SendtoDeck(Duel.GetFieldGroup(p,0xff,0),nil,-2,REASON_RULE) --exile all cards for all players
                    LoadDeck(p,22,1)
                    LoadDeck(p,10,2)
                    LoadDeck(p,7,3)
                    LoadDeck(p,8,4)
                    LoadDeck(p,4,5)

                    AddCardSpecial(p,team,{511002807, 511002883},44508094,LOCATION_DECK,LOCATION_EXTRA)
                    AddCardSpecial(p,team,{44935634},60071928,LOCATION_DECK,LOCATION_DECK)
                    AddCardSpecial(p,team,{44508094},212,LOCATION_EXTRA,LOCATION_DECK,{61257789},LOCATION_DECK)
                    AddCardSpecial(p,team,{44508094},61257789,LOCATION_EXTRA,LOCATION_DECK,{212},LOCATION_DECK)
                    AddCardSpecial(p,team,{71971554},2322421,LOCATION_DECK,LOCATION_EXTRA)
                    AddCardSpecial(p,team,{96182448},18013090,LOCATION_DECK,LOCATION_EXTRA)
                    AddCardSpecial(p,team,{67270095},46195773,LOCATION_DECK,LOCATION_EXTRA)
                    AddCardSpecial(p,team,{511002910},511001982,LOCATION_DECK,LOCATION_EXTRA)
                    AddCardSpecial(p,team,{21159309},7841112,LOCATION_DECK,LOCATION_EXTRA)
                    AddCardSpecial(p,team,{21159309},44508094,LOCATION_DECK,LOCATION_EXTRA)
                    AddCardSpecial(p,team,{47264717,511002520,511002519},44508094,LOCATION_DECK,LOCATION_EXTRA)
                    AddCardSpecial(p,team,{513000056},44508094,LOCATION_DECK,LOCATION_EXTRA)
                    AddCardSpecial(p,team,{513000056},513000012,LOCATION_DECK,LOCATION_EXTRA)
                    AddCardSpecial(p,team,{513000012,511001658,513000031,371,511000774},511001963,LOCATION_EXTRA,LOCATION_EXTRA)

                    Debug.ReloadFieldEnd()
                    Duel.ShuffleDeck(p)
                    Duel.ShuffleExtra(p)

                    if counts[p]~=1 then
                        Duel.TagSwap(p) --loop to other players deck
                    end
				end
			end
		end
		e:Reset()
	end
	finishsetup()
end