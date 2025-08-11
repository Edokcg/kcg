--王冠爆炸 (K)
function c127.initial_effect(c)
	   local e1=Effect.CreateEffect(c)
	   e1:SetDescription(aux.Stringid(10584050,0))
	   e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	   e1:SetType(EFFECT_TYPE_ACTIVATE)
	   e1:SetCode(EVENT_FREE_CHAIN)
	   e1:SetCondition(c127.con)
	   e1:SetTarget(c127.target)
	   e1:SetOperation(c127.operation)
	   c:RegisterEffect(e1)
end

function c127.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c127.ffilter,tp,LOCATION_SZONE,0,1,nil)
end
function c127.filter(c)
	return c:IsCode(100000370) and c:IsFaceup() and c:GetCounter(0x95)>0
end
function c127.ffilter(c)
	return c:IsCode(111215001) and c:IsFaceup() and not c:IsDisabled() and c:GetSequence()==5
end
function c127.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetMatchingGroup(c127.filter,tp,LOCATION_SZONE,0,nil)
	local c=tg:GetFirst()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c:IsCanRemoveCounter(tp,0x95,c:GetCounter(0x95),REASON_EFFECT) and c127.filter(chkc) end
	  if chk==0 then return Duel.IsExistingTarget(c127.filter,tp,LOCATION_SZONE,0,1,nil) 
		 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c127.filter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c127.operation(e,tp,eg,ep,ev,re,r,rp)
	  local tg=Duel.GetFirstTarget()
	  if not tg:IsRelateToEffect(e) or tg:IsFacedown() then return end
	local count=tg:GetCounter(0x95) local count2=count
	  local c=e:GetHandler()
	  tg:RemoveCounter(tp,0x95,count,REASON_EFFECT)
	  local g2=Duel.GetFirstMatchingCard(c127.ffilter,tp,LOCATION_SZONE,0,nil)
	  if not g2 then return end
	  local ft=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	  if Duel.GetLocationCount(tp,LOCATION_MZONE)<count and ft>0 then
			if ft+Duel.GetLocationCount(tp,LOCATION_MZONE)<count then count=ft end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local ag=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,count,count,nil)
		if #ag>0 then Duel.Destroy(ag,REASON_REPLACE+REASON_RULE) end
	  end
	  local ft2=Duel.GetLocationCount(tp,LOCATION_MZONE)
	  if ft2<count2 then count2=ft2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ZONE)
	local dis=Duel.SelectDisableField(tp,count2,LOCATION_MZONE,0,0)
	  for i=1,count2 do
			g2:RegisterFlagEffect(126,RESET_EVENT+0x1fe0000,0,1)  
	  end  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetLabel(dis)
	e2:SetOperation(c127.disop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	g2:RegisterEffect(e2)
end
function c127.disop(e,tp)
	-- local c=Duel.GetLocationCount(tp,LOCATION_MZONE)
	-- local dis1=0
	  -- if e:GetLabel()>c then 
	  --	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	  --	   local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,e:GetLabel()-c,e:GetLabel()-c,nil)
	  --	   if Duel.Destroy(g,REASON_RULE)>0 then
	  --			 c=Duel.GetLocationCount(tp,LOCATION_MZONE)
	  --			 dis1=Duel.SelectDisableField(tp,c,LOCATION_MZONE,0,0)
	  --			 for i=1,c do
	  --				   e:GetHandler():RegisterFlagEffect(126,RESET_EVENT+0x1fe0000,0,1)  
	  --			 end  
	  --	   end  
	  -- else 
	  --	   dis1=Duel.SelectDisableField(tp,e:GetLabel(),LOCATION_MZONE,0,0)  
	  --	   for i=1,e:GetLabel() do
	  --			 e:GetHandler():RegisterFlagEffect(126,RESET_EVENT+0x1fe0000,0,1)  
	  --	   end 
	  -- end
	  -- return dis1
	return e:GetLabel()
end
