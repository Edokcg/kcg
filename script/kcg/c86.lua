local s,id=GetID()
if s then
	function s.initial_effect(c)
	end
end
if not id then id=86 end
if not KField then
	KField={}
	local function finishsetup()
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_STARTUP)
		e1:SetCondition(KField.con)
		e1:SetOperation(KField.op)
		Duel.RegisterEffect(e1,0)
    end

	function KField.con(e, tp, eg, ep, ev, re, r, rp)
        return Duel.GetFlagEffect(0, id) == 0
    end
	function KField.op(e,tp,eg,ep,ev,re,r,rp)
		Duel.RegisterFlagEffect(0, id, 0, 0, 1)
		local kp={0,1}	
		for _,ttp in ipairs(kp) do
			if Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_EXTRA, 0, nil, 111) > 0 then
				aux.AIchk[ttp] = 1
			end
			local opt=Duel.SelectOption(ttp,aux.Stringid(826,15),aux.Stringid(826,14))
			if opt==1 then
				local tk=0
				if aux.AIchk[ttp]==1 then 
					Duel.Hint(HINT_SELECTMSG,ttp,HINTMSG_CODE) 
					tk=Duel.AnnounceCard(ttp,TYPE_FIELD,OPCODE_ISTYPE,OPCODE_ALLOW_ALIASES,OPCODE_ALLOW_TOKENS)
				else 
					Duel.Hint(HINT_SELECTMSG,ttp,HINTMSG_CODE) 
					tk=Duel.AnnounceCard(ttp,TYPE_FIELD,OPCODE_ISTYPE,OPCODE_ALLOW_ALIASES)
				end
				if tk~=0 then
					local token=Duel.CreateToken(ttp,tk)
					if not Duel.MoveToField(token,ttp,ttp,LOCATION_FZONE,POS_FACEUP,true) then return end
					if token:IsType(TYPE_TOKEN) then token:SetCardData(CARDDATA_TYPE, token:GetType()-TYPE_TOKEN) end
					local te,eg,ep,ev,re,r,rp=token:CheckActivateEffect(true,true,true)
					local tep=token:GetControler()
					local condition=te:GetCondition()
					local cost=te:GetCost()
					Duel.ClearTargetCard()
					local target=te:GetTarget()
					local operation=te:GetOperation()
					Duel.Hint(HINT_CARD,0,token:GetOriginalCode())
					token:CreateEffectRelation(te)
					if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
					if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
					local gg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					if gg then
						local etc=gg:GetFirst()
						while etc do
							etc:CreateEffectRelation(te)
							etc=gg:GetNext()
						end
					end
					Duel.BreakEffect()
					if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
					token:ReleaseEffectRelation(te)
					if gg then  
						local etc=gg:GetFirst()								
						while etc do
							etc:ReleaseEffectRelation(te)
							etc=gg:GetNext()
						end
					end 
				end
			else
				if Duel.IsExistingMatchingCard(Card.IsType,ttp,LOCATION_DECK+LOCATION_HAND,0,1,nil,TYPE_FIELD) then
					Duel.Hint(HINT_SELECTMSG,ttp,HINTMSG_SET)
					local token=Duel.SelectMatchingCard(ttp,Card.IsType,ttp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,TYPE_FIELD):GetFirst()
					if not token then return end
					if not Duel.MoveToField(token,ttp,ttp,LOCATION_FZONE,POS_FACEUP,true) then return end
					local te,eg,ep,ev,re,r,rp=token:CheckActivateEffect(true,true,true)
					local tep=token:GetControler()
					local condition=te:GetCondition()
					local cost=te:GetCost()
					Duel.ClearTargetCard()
					local target=te:GetTarget()
					local operation=te:GetOperation()
					Duel.Hint(HINT_CARD,0,token:GetOriginalCode())
					token:CreateEffectRelation(te)
					if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
					if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
					local gg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					if gg then
						local etc=gg:GetFirst()
						while etc do
							etc:CreateEffectRelation(te)
							etc=gg:GetNext()
						end
					end
					Duel.BreakEffect()
					if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
					token:ReleaseEffectRelation(te)
					if gg then  
						local etc=gg:GetFirst()								
						while etc do
							etc:ReleaseEffectRelation(te)
							etc=gg:GetNext()
						end
					end 				
				end
			end
		end	 
		if Duel.GetMatchingGroupCount(Card.IsCode,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,id)>0 then 
			Duel.SendtoDeck(Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,id),0,-2,REASON_RULE)
		end		
		e:Reset()
	end

	finishsetup()
end   