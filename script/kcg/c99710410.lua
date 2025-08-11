--娱乐模式-1
local selfs={}
if self_table then
	function self_table.initial_effect(c) table.insert(selfs,c) end
end
local id=99710410
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
	function LoadDeck(tp,mainSize,extraSize,mg,eg)
		if mainSize>0 then
			local hg=Duel.GetRandomGroup(tp,mainSize,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP,0,0,0x2000,0,false)
			mg:Merge(hg)
		end
		if extraSize>0 then
			local hg=Duel.GetRandomGroup(tp,extraSize,TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION,0,0,0x2000,0,true)
			eg:Merge(hg)
		end
	end
	function AddDeck(tp,g,loc)
		local tc=g:GetFirst()
		local code=0
		while tc do
			code=tc:GetOriginalCode()
			Debug.AddCard(code,tp,tp,loc,1,POS_FACEDOWN_DEFENSE)
			tc=g:GetNext()
		end
	end
	function ModeGame_1.stop(e,tp,eg,ep,ev,re,r,rp)
		for _,card in ipairs(selfs) do
			Duel.SendtoDeck(card,0,-2,REASON_RULE) --exile this card
		end
		Duel.DisableShuffleCheck()

		local counts={}
		counts[0]=Duel.GetPlayersCount(0)
		counts[1]=Duel.GetPlayersCount(1)
		-- local groups={}
		-- groups[0]={}
		-- groups[1]={}
		-- for i=1,counts[0] do
		-- 	groups[0][i]={}
		-- end
		-- for i=1,counts[1] do
		-- 	groups[1][i]={}
		-- end

		for p=0,1 do
            if Duel.GetMatchingGroupCount(Card.IsCode, p, LOCATION_EXTRA, 0, nil, 111) > 0 then
				aux.AIchk[p]=1
                aux.AIchk[1-p]=0
                break
			end
        end
		for p=0,1 do
            if aux.AIchk[p]==1 then
			    for team=1,counts[p] do
                    local opt=0
                    local aideckcount=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
                    if aideckcount<1 then --random ai
                        opt=Duel.SelectOption(1-p,aux.Stringid(id,0),aux.Stringid(id,1)) --ask non-ai players to choose random deck or not
                    end
                    local mg=Group.CreateGroup()
                    local eg=Group.CreateGroup()
                    local mainSize=Duel.GetRandomNumber(40,60)
                    local extraSize=Duel.GetRandomNumber(0,15)
                    local mainSize_2=Duel.GetRandomNumber(40,60)
                    local extraSize_2=Duel.GetRandomNumber(0,15)
                    local mg_2=Group.CreateGroup()
                    local eg_2=Group.CreateGroup()
                    local mg_3=Group.CreateGroup()
                    local eg_3=Group.CreateGroup()
				    --random deck
                    if opt==0 then
                        LoadDeck(1-p,mainSize,extraSize,mg,eg)
                    else
                        local times=0
                        while times<4 do
                            local hg=Duel.GetRandomGroup(1-p,40,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP,0,0,0x2000,0,false)
                            Duel.Hint(HINT_SELECTMSG,1-p,aux.Stringid(id,2))
                            hg=hg:Select(1-p,10,10,nil)
                            mg:Merge(hg)
                            times=times+1
                        end
                        times=0
                        while times<2 do
                            local hg=Duel.GetRandomGroup(1-p,8,TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION,0,0,0x2000,0,true)
                            Duel.Hint(HINT_SELECTMSG,1-p,aux.Stringid(id,3))
                            hg=hg:Select(1-p,3,3,nil)
                            eg:Merge(hg)
                            times=times+1
                        end
                    end
                    AddDeck(1-p,mg,LOCATION_DECK)
                    AddDeck(1-p,eg,LOCATION_EXTRA)
                    if aideckcount<1 then --non-random deck, random ai add cards
                        LoadDeck(p,mainSize_2,extraSize_2,mg_2,eg_2)
                        AddDeck(p,mg_2,LOCATION_DECK)
                        AddDeck(p,eg_2,LOCATION_EXTRA)
                    end
                    if opt==1 and aideckcount<1 then --non-random deck, random ai add cards
                        LoadDeck(p,mainSize,extraSize,mg_3,eg_3)
                        AddDeck(p,mg_3,LOCATION_DECK)
                        AddDeck(p,eg_3,LOCATION_EXTRA)
                    end
                    Debug.ReloadFieldEnd()
                    Duel.ShuffleDeck(1-p)
                    Duel.ShuffleExtra(1-p)
                    mg:DeleteGroup()
                    eg:DeleteGroup()
                    mg_2:DeleteGroup()
                    eg_2:DeleteGroup()
                    mg_3:DeleteGroup()
                    eg_3:DeleteGroup()
                    
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