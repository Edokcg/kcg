local s, id = GetID()
function s.initial_effect(c)
   if not AISystem then
   AISystem=true
   tempg = {}
	tempg[0]=Group.CreateGroup()
	tempg[0]:KeepAlive()
	tempg[1]=Group.CreateGroup()
	tempg[1]:KeepAlive()
   local e0 = Effect.CreateEffect(c)
   e0:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
   e0:SetCode(EVENT_STARTUP)
   e0:SetOperation(s.op)
   Duel.RegisterEffect(e0, 0)
   end
      
   local e1=Effect.CreateEffect(c)
   e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
   e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
   e1:SetCode(EVENT_PRECHAINING)
   e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
      local ttp = e:GetOwner():GetControler()
      local rc = re:GetHandler()
      return Duel.GetFlagEffect(ttp, id) == 0 and rp == 1 - ttp 
      and not rc:IsImmuneToEffect(e) and Duel.IsChainNegatable(ev) and not rc:IsDisabled()
      and Duel.GetMatchingGroupCount(s.AIcounter4, ttp, LOCATION_HAND + LOCATION_SZONE, 0, nil) > 0
      and Duel.GetFieldGroupCount(ttp, LOCATION_DECK, 0) > 0
   end)
   e1:SetOperation(s.reverse_chain)
   Duel.RegisterEffect(e1, 0) 
   local e3=e1:Clone()	
   e3:SetCode(EVENT_PREATTACK_ANNOUNCE)
   e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
      local ttp = e:GetOwner():GetControler()
      return Duel.GetFlagEffect(ttp, id+1) == 0 and ep == 1 - ttp 
      and not Duel.GetAttacker():IsImmuneToEffect(e)
      and Duel.GetMatchingGroupCount(s.AIcounter4, ttp, LOCATION_HAND + LOCATION_SZONE, 0, nil) > 0
      and Duel.GetFieldGroupCount(ttp, LOCATION_DECK, 0) > 0
   end)
   e3:SetOperation(s.reverse_attack)
   Duel.RegisterEffect(e3, 0)
   local e4=e1:Clone()	
   e4:SetCode(EVENT_PRESPSUMMON_SUCCESS)
   e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
      local ttp = e:GetOwner():GetControler()
      return Duel.GetFlagEffect(ttp, id+2) == 0 and ep == 1 - ttp
      and Duel.GetMatchingGroupCount(s.AIcounter4, ttp, LOCATION_HAND, 0, nil) > 0
      and Duel.GetFieldGroupCount(ttp, LOCATION_DECK, 0) > 0
   end)
   e4:SetOperation(s.reverse_sp)
   Duel.RegisterEffect(e4, 0)
end

function s.op(e, tp, eg, ep, ev, re, r, rp)
   local ttp = e:GetOwner():GetControler()
   local code={58851034,14558127,59438930,67750322,73642296,77538567,10045474,97268402,37742478,18964575,19665973,27204311,55063751,23434538}
   if Duel.GetMatchingGroupCount(Card.IsCode, ttp, LOCATION_EXTRA, 0, nil, id) > 0 then
      Duel.DisableShuffleCheck()
      Duel.SendtoDeck(Duel.GetMatchingGroup(Card.IsCode, ttp, LOCATION_EXTRA, 0, nil, id),0,-2,REASON_RULE)
      for _, code1 in ipairs(code) do
         local token = Duel.CreateToken(ttp, code1)
         tempg[ttp]:AddCard(token)
      end
   end
   if Duel.GetMatchingGroupCount(Card.IsCode, 1-ttp, LOCATION_EXTRA, 0, nil, id) > 0 then
      Duel.DisableShuffleCheck()
      Duel.SendtoDeck(Duel.GetMatchingGroup(Card.IsCode, 1-ttp, LOCATION_EXTRA, 0, nil, id),0,-2,REASON_RULE)
      for _, code1 in ipairs(code) do
         local token = Duel.CreateToken(1-ttp, code1)
         tempg[1-ttp]:AddCard(token)
      end
   end
   e:Reset()
end

function s.reverse_chain(e,tp,eg,ep,ev,re,r,rp)
   local code={58851034,14558127,59438930,67750322,73642296,77538567,10045474,97268402}
   local ttp = e:GetOwner():GetControler()
   s.treverse(0,code,e,ttp,eg,ep,ev,re,r,rp)
end
function s.reverse_attack(e,tp,eg,ep,ev,re,r,rp)
   local code={37742478,18964575,19665973}
   local ttp = e:GetOwner():GetControler()
   s.treverse(1,code,e,ttp,eg,ep,ev,re,r,rp)
end
function s.reverse_sp(e,tp,eg,ep,ev,re,r,rp)
   local code={27204311,23434538}
   local ttp = e:GetOwner():GetControler()
   if Duel.GetTurnPlayer()==ttp then code={27204311,55063751,23434538} end
   s.treverse(2,code,e,ttp,eg,ep,ev,re,r,rp)
end

function s.treverse(case,code,e,tp,eg,ep,ev,re,r,rp)
   local event=e:GetCode()
   local reset = RESET_PHASE+PHASE_MAIN1+PHASE_MAIN2+PHASE_BATTLE+PHASE_DAMAGE+PHASE_END
   local loc = LOCATION_SZONE
   for _, code1 in ipairs(code) do
      local g = tempg[tp]:Filter(Card.IsCode,nil,code1):GetFirst()
      local g2 = nil
      if not g then goto continue end
      -- local mt = Duel.GetMetatable(code1)
      -- if not mt then goto continue end
      local te={}
      local tae={g:GetTriggerEffect()}
      local ae=tae[1]
      if not ae then goto continue end
      if g:IsOriginalType(TYPE_MONSTER) then loc = LOCATION_HAND end
      if g:IsOriginalType(TYPE_SPELL+TYPE_TRAP) then
         local ce={g:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND)}
         for _, se in ipairs(ce) do
            local con=se:GetCondition()
            if con==nil or con(se,tp,eg,ep,ev,re,r,rp) then
               loc = LOCATION_HAND
            end
         end
      end
      if Duel.IsExistingMatchingCard(s.AIcounter2,tp,loc,0,1,nil,code1) and not Duel.IsExistingMatchingCard(s.AIcounter,tp,loc,0,1,nil,code1) then
         if bit.band(loc, LOCATION_HAND)~=0 and Duel.IsExistingMatchingCard(s.AIcounter2,tp,LOCATION_HAND,0,1,nil,code1) then
            g2=Duel.GetFirstMatchingCard(s.AIcounter2,tp,LOCATION_HAND,0,nil,code1)
         else
            g2=Duel.GetFirstMatchingCard(s.AIcounter2,tp,loc,0,nil,code1)
         end
         if not g2 then goto continue end
         local chkcon=false
         if g:IsOriginalType(TYPE_SPELL+TYPE_TRAP) then
            if g:CheckActivateEffect(false,false,false)==nil or te==nil then goto continue end
            te={g:GetActivateEffect()}
            if g:IsOriginalType(TYPE_TRAP+TYPE_QUICKPLAY) and g2:IsLocation(LOCATION_SZONE) and g2:GetTurnID()==Duel.GetTurnCount() then goto continue end
         else
            te=tae
            -- if code1==14558127 then chkcon=mt.discon(ae,tp,eg,ep,ev,re,r,rp) and mt.discost(ae,tp,eg,ep,ev,re,r,rp,0) and mt.distg(ae,tp,eg,ep,ev,re,r,rp,0) end
            -- if code1==59438930 then chkcon=mt.condition(ae,tp,eg,ep,ev,re,r,rp) and mt.cost(ae,tp,eg,ep,ev,re,r,rp,0) and mt.target(ae,tp,eg,ep,ev,re,r,rp,0) end
            -- if code1==73642296 then chkcon=mt.discon(ae,tp,eg,ep,ev,re,r,rp) and mt.discost(ae,tp,eg,ep,ev,re,r,rp,0) and mt.distg(ae,tp,eg,ep,ev,re,r,rp,0) end
            -- if code1==67750322 then chkcon=mt.discon(ae,tp,eg,ep,ev,re,r,rp) and mt.discost(ae,tp,eg,ep,ev,re,r,rp,0) and mt.distg(ae,tp,eg,ep,ev,re,r,rp,0) end
            -- if code1==97268402 then chkcon=mt.condition(ae,tp,eg,ep,ev,re,r,rp) and mt.cost(ae,tp,eg,ep,ev,re,r,rp,0) and mt.target(ae,tp,eg,ep,ev,re,r,rp,0) end
            -- if code1==37742478 then chkcon=mt.condition2(ae,tp,eg,ep,ev,re,r,rp) and mt.cost2(ae,tp,eg,ep,ev,re,r,rp,0) end
            -- if code1==18964575 then chkcon=mt.condition(ae,tp,eg,ep,ev,re,r,rp) and mt.cost(ae,tp,eg,ep,ev,re,r,rp,0) end
            -- if code1==19665973 then chkcon=mt.condition(ae,tp,eg,ep,ev,re,r,rp) and mt.target(ae,tp,eg,ep,ev,re,r,rp,0) end
            -- if code1==27204311 then
            --    local gg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsReleasableByEffect),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
            --    chkcon=mt.condition(ae,tp,eg,ep,ev,re,r,rp)
            --    and #gg>0 and Duel.GetMZoneCount(tp,gg,tp)>0 and Duel.GetMZoneCount(1-tp,gg,tp)>0
            --    and Duel.IsPlayerCanSpecialSummonCount(tp,2)
            --    and Duel.IsPlayerCanSpecialSummonMonster(tp,27204311+1,0,TYPES_TOKEN,gg:GetSum(Card.GetBaseAttack),gg:GetSum(Card.GetBaseDefense),11,RACE_ROCK,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp)
            -- end
            -- if code1==55063751 then
            --    local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil)
            --    chkcon=aux.SelectUnselectGroup(mg,e,tp,1,1,aux.LavaCheck,0)
            -- end
         end
         for _, se in ipairs(te) do
            local con=se:GetCondition()
            local cost=se:GetCost()
            local tg=se:GetTarget()
            if se:GetType()~=EFFECT_TYPE_IGNITION 
            and ((con==nil or con(se,tp,eg,ep,ev,re,r,rp)) and (cost==nil or cost(se,tp,eg,ep,ev,re,r,rp,0)) and (tg==nil or tg(se,tp,eg,ep,ev,re,r,rp,0))) then chkcon=true end
         end
         if not chkcon then goto continue end
   
         if event == EVENT_CHAINING then
            if code1==59438930 then 
               if not re or not re:GetHandler():IsDestructable() then goto continue end
            end
         end

         local rtoken = Duel.CreateToken(tp, code1)
         Duel.DisableShuffleCheck()
         Duel.SendtoDeck(g,tp,0,REASON_RULE)
         tempg[tp]:AddCard(rtoken)
         aux.SwapEntity(g, g2)

         Duel.RegisterFlagEffect(tp,id+case,reset,0,1)
         break
      end
      ::continue::
   end
end

function s.AIcounter(c,code)
   return c:GetOriginalCode()==code and (c:IsLocation(LOCATION_HAND) or (c:IsFacedown() and c:GetSequence()<5))
end
function s.AIcounter2(c,code)
   return c:GetOriginalCode()~=code and (c:IsLocation(LOCATION_HAND) or (c:IsFacedown() and c:GetSequence()<5))
end
function s.AIcounter4(c)
   return (c:IsLocation(LOCATION_HAND) or (c:IsFacedown() and c:GetSequence()<5))
end
