 --上古死灵钥匙(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		  c:SetUniqueOnField(1,0,aux.FilterBoolFunction(s.limfilter),LOCATION_SZONE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate2)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)
---check
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(0x1ff)
	e4:SetCountLimit(1)
	e4:SetOperation(s.chop)
	c:RegisterEffect(e4)
end
function s.limfilter(c)
return c:IsCode(77240324) or c:IsCode(77240329) or c:IsCode(77240330) or c:IsCode(77240331) or c:IsCode(77240332) or c:IsCode(77240333) or c:IsCode(77240334)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
-------------------------------手卡
   local tp=e:GetHandler():GetControler()
   local num=Duel.GetTurnCount()
   _G["mhp"..num]=Duel.GetLP(tp)
   _G["ehp"..num]=Duel.GetLP(1-tp)
   local mhg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
	_G["mhg"..num]={}
	if mhg~=nil then
	  local mhc=mhg:GetFirst()
		while mhc do
		table.insert(_G["mhg"..num],mhc:GetOriginalCode())
		mhc=mhg:GetNext()   
		end
	end
------------------------手卡
 local ehg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
	_G["ehg"..num]={}
	if ehg~=nil then
		local ehc=ehg:GetFirst()
		while ehc do
		table.insert(_G["ehg"..num],ehc:GetOriginalCode())
		ehc=ehg:GetNext()   
		end
	end
------------------------墓地
 local mgg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
	_G["mgg"..num]={}
	if mgg~=nil then
	  local mgc=mgg:GetFirst()
		while mgc do
		table.insert(_G["mgg"..num],mgc:GetOriginalCode())
		mgc=mgg:GetNext()   
		end
	end
------------------------墓地
local egg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_GRAVE,nil)
   _G["egg"..num]={}
	if egg~=nil then
	  local egc=egg:GetFirst()
		while egc do
	   table.insert(_G["egg"..num],egc:GetOriginalCode())
		egc=egg:GetNext()   
		end
	end
------------------------除外
 local mrg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
	_G["mrg"..num]={}
	_G["mBool"..num]={}
	if mrg~=nil then
	  local mrc=mrg:GetFirst()
		while mrc do
			if mrc:IsFaceup() then
			table.insert(_G["mBool"..num],0)
			elseif mrc:IsFacedown() then
			table.insert(_G["mBool"..num],1)
		end
		table.insert(_G["mrg"..num],mrc:GetOriginalCode())
		mrc=mrg:GetNext()   
		end
	end
------------------------除外
local erg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_REMOVED,nil)
   _G["erg"..num]={}
   _G["eBool"..num]={}
	if erg~=nil then
	  local erc=erg:GetFirst()
	   while erc do
		if erc:IsFaceup() then
		table.insert(_G["eBool"..num],0)
		elseif erc:IsFacedown() then
		table.insert(_G["eBool"..num],1)
	   end
	   table.insert(_G["erg"..num],erc:GetOriginalCode())
		erc=erg:GetNext()   
		end
	end
------------------------额外
 local mxg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_EXTRA,0,nil)
	_G["mxg"..num]={}
	_G["mxBool"..num]={}
	if mxg~=nil then
	  local mxc=mxg:GetFirst()
		while mxc do
			if mxc:IsFaceup() then
			table.insert(_G["mxBool"..num],0)
			elseif mxc:IsFacedown() then
			table.insert(_G["mxBool"..num],1)
		end
		table.insert(_G["mxg"..num],mxc:GetOriginalCode())
		mxc=mxg:GetNext()   
		end
	end
------------------------额外
local exg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
   _G["exg"..num]={}
   _G["exBool"..num]={}
	if exg~=nil then
	  local exc=exg:GetFirst()
	   while exc do
		if exc:IsFaceup() then
		table.insert(_G["exBool"..num],0)
		elseif exc:IsFacedown() then
		table.insert(_G["exBool"..num],1)
	   end
	   table.insert(_G["exg"..num],exc:GetOriginalCode())
		exc=exg:GetNext()   
		end
	end
------------------------卡组
local mdg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
	_G["mdg"..num]={}
	if mdg~=nil then
	  local mdc=mdg:GetFirst()
		while mdc do
		table.insert(_G["mdg"..num],mdc:GetOriginalCode())
		mdc=mdg:GetNext()   
		end
	end
------------------------卡组
local edg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_DECK,nil)
	_G["edg"..num]={}
	if edg~=nil then
	  local edc=edg:GetFirst()
		while edc do
		table.insert(_G["edg"..num],edc:GetOriginalCode())
		edc=edg:GetNext()   
		end
	end
------------------------怪兽区
local mog=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
	_G["mog"..num]={}
	_G["msTable"..num]={}
	_G["mpTable"..num]={}
	_G["mlTable"..num]={}
	if mog~=nil then
	  local moc=mog:GetFirst()
		while moc do
		table.insert(_G["msTable"..num],moc:GetSequence())
		table.insert(_G["mog"..num],moc:GetOriginalCode())
		table.insert(_G["mpTable"..num],moc:GetPosition())
		table.insert(_G["mlTable"..num],moc:GetLocation())
		moc=mog:GetNext()   
		end
	end
------------------------怪兽区
local eog=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
   _G["eog"..num]={}
   _G["esTable"..num]={}
   _G["epTable"..num]={}
   _G["elTable"..num]={}
	if eog~=nil then
	  local eoc=eog:GetFirst()
		while eoc do
		table.insert(_G["esTable"..num],eoc:GetSequence())
		table.insert(_G["eog"..num],eoc:GetOriginalCode())  
		table.insert(_G["epTable"..num],eoc:GetPosition())
		table.insert(_G["elTable"..num],eoc:GetLocation())
		eoc=eog:GetNext()   
		end
	end
------------------------魔陷区
local mzg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,e:GetHandler())
	_G["mzg"..num]={}
	_G["mszTable"..num]={}
	_G["mpzTable"..num]={}
	_G["mlzTable"..num]={}
	if mzg~=nil then
	  local mzc=mzg:GetFirst()
		while mzc do
		table.insert(_G["mszTable"..num],mzc:GetSequence())
		table.insert(_G["mzg"..num],mzc:GetOriginalCode())
		table.insert(_G["mpzTable"..num],mzc:GetPosition())
		table.insert(_G["mlzTable"..num],mzc:GetLocation())
		mzc=mzg:GetNext()   
		end
	end
------------------------魔陷区
local ezg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,e:GetHandler())
   _G["ezg"..num]={}
   _G["eszTable"..num]={}
   _G["epzTable"..num]={}
   _G["elzTable"..num]={}
	if ezg~=nil then
	  local ezc=ezg:GetFirst()
		while ezc do
		table.insert(_G["eszTable"..num],ezc:GetSequence())
		table.insert(_G["ezg"..num],ezc:GetOriginalCode())  
		table.insert(_G["epzTable"..num],ezc:GetPosition())
		table.insert(_G["elzTable"..num],ezc:GetLocation())
		ezc=ezg:GetNext()   
		end
	end
------------------------
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local turnNum=Duel.GetTurnCount()
	local l=1
	while l<=turnNum do
		t[l]=l
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local num=Duel.AnnounceNumber(tp,table.unpack(t))
------------------------怪兽区
   local mog=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
   if #mog~=0 then
   local ovc=mog:GetFirst()
   while ovc do
		if ovc:GetOverlayGroup()~=nil then
		local og=ovc:GetOverlayGroup()
		local tc=og:GetFirst()
		while tc do
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
			tc=og:GetNext()
		end
end
ovc=mog:GetNext()
end
   if #mog>0 then Duel.SendtoDeck(mog,0,-2,REASON_RULE) end
   end
   local mNum=1
   while mNum<=#_G["mog"..num] do
	 local sq=e:GetHandler():GetSequence()
	 local tc=Duel.CreateToken(tp,_G["mog"..num][mNum])
	 if _G["msTable"..num][mNum]~=sq and _G["mlTable"..num][mNum]~=nil and _G["mpTable"..num][mNum]~=nil and _G["msTable"..num][mNum]~=nil and Duel.GetLocationCount(tp,_G["mlTable"..num][mNum],_G["msTable"..num][mNum])>0 then
	 Duel.MoveToField(tc, tp, tp, _G["mlTable"..num][mNum], _G["mpTable"..num][mNum],true, _G["msTable"..num][mNum])
	  end
	  mNum=mNum+1
	end
------------------------怪兽区
	 local eog=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
   if #eog~=0 then
	local ovc2=eog:GetFirst()
	  while ovc2 do
	   if ovc2:GetOverlayGroup()~=nil then
	   local og=ovc2:GetOverlayGroup()
	   local tc=og:GetFirst()
	   while tc do
		Duel.SendtoDeck(tc,0,-2,REASON_RULE)
	   tc=og:GetNext()
		end
end
ovc2=eog:GetNext()
end
  
   if #eog>0 then Duel.SendtoDeck(eog,0,-2,REASON_RULE) end
   end
   local mNum=1
   while mNum<=#_G["eog"..num] do 
	 local sq=e:GetHandler():GetSequence()
	 local tc=Duel.CreateToken(1-tp,_G["eog"..num][mNum]) 
	 if _G["esTable"..num][mNum]~=sq and _G["epTable"..num][mNum]~=nil and _G["elTable"..num][mNum]~=nil and _G["esTable"..num][mNum]~=nil and Duel.GetLocationCount(1-tp,_G["elTable"..num][mNum],_G["esTable"..num][mNum])>0 then
	 Duel.MoveToField(tc, 1-tp, 1-tp, _G["elTable"..num][mNum], _G["epTable"..num][mNum],true, _G["esTable"..num][mNum])
		end
	 mNum=mNum+1
	end
------------------------魔陷区
   local mzg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,e:GetHandler())
   if #mzg~=0 then
   local ovc3=mzg:GetFirst()
   while ovc3 do
		if ovc3:GetOverlayGroup()~=nil then
		local og=ovc3:GetOverlayGroup()
		local tc=og:GetFirst()
		while tc do
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		tc=og:GetNext()
		end
end
ovc3=mzg:GetNext()
end
   if #mzg>0 then Duel.SendtoDeck(mzg,0,-2,REASON_RULE) end
   end
   local mNum=1
   while mNum<=#_G["mzg"..num] do
	 local sq=e:GetHandler():GetSequence()
	 local tc=Duel.CreateToken(tp,_G["mzg"..num][mNum])
	 if _G["mszTable"..num][mNum]~=sq and _G["mlzTable"..num][mNum]~=nil and _G["mpzTable"..num][mNum]~=nil and _G["mszTable"..num][mNum]~=nil and Duel.GetLocationCount(tp,_G["mlzTable"..num][mNum],_G["mszTable"..num][mNum])>0 then 
	 Duel.MoveToField(tc, tp, tp, _G["mlzTable"..num][mNum], _G["mpzTable"..num][mNum],true, _G["mszTable"..num][mNum])
		end
	  mNum=mNum+1
	end
------------------------魔陷区
	 local ezg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,e:GetHandler())
   if #ezg~=0 then
   local ovc4=ezg:GetFirst()
   while ovc4 do
		if ovc4:GetOverlayGroup()~=nil then
		local og=ovc4:GetOverlayGroup()
		local tc=og:GetFirst()
		while tc do
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		tc=og:GetNext()
		end
end
ovc4=ezg:GetNext()
end
   if #ezg>0 then Duel.SendtoDeck(ezg,0,-2,REASON_RULE) end
   end
   local mNum=1
   while mNum<=#_G["ezg"..num] do
	 local sq=e:GetHandler():GetSequence()
	 local tc=Duel.CreateToken(1-tp,_G["ezg"..num][mNum]) 
	 if _G["eszTable"..num][mNum]~=sq and _G["epzTable"..num][mNum]~=nil and _G["elzTable"..num][mNum]~=nil and _G["eszTable"..num][mNum]~=nil and Duel.GetLocationCount(1-tp,_G["elzTable"..num][mNum],_G["eszTable"..num][mNum])>0 then
	 Duel.MoveToField(tc, 1-tp, 1-tp, _G["elzTable"..num][mNum], _G["epzTable"..num][mNum],true, _G["eszTable"..num][mNum])
		end
	 mNum=mNum+1
	end
------------------------手卡
  local mhg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
  if #mhg~=0 and #mhg==#_G["mhg"..num] then
	local time=1 
	local tc=mhg:GetFirst() 
	while time<=#mhg  and tc do
		if tc:GetOriginalCode()~=_G["mhg"..num][time] then
		   tc:SetEntityCode(_G["mhg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		end
		time=time+1
		tc=mhg:GetNext()
	end
  elseif #mhg>#_G["mhg"..num] then
	local time=1  
	local tc=mhg:GetFirst() 
	while time<=#mhg and tc do 
		if time<=#_G["mhg"..num] and tc:GetOriginalCode()~=_G["mhg"..num][time] then
		   tc:SetEntityCode(_G["mhg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#_G["mhg"..num] then
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		end
		time=time+1   
		tc=mhg:GetNext()
		end
  elseif #mhg<#_G["mhg"..num] and #mhg~=0 then
	local time=1 
	local tc=mhg:GetFirst() 
	while time<=#_G["mhg"..num] do
		if time<=#mhg and tc:GetOriginalCode()~=_G["mhg"..num][time] then
		   tc:SetEntityCode(_G["mhg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#mhg then
			local tc2=Duel.CreateToken(tp,_G["mhg"..num][time])
			Duel.SendtoHand(tc2,tp,REASON_RULE)
		end
		time=time+1
		tc=mhg:GetNext()   
		end 
   elseif #mhg==0 and #_G["mhg"..num]~=0 then
		local time=1 
		while time<=#_G["mhg"..num]  do
			local tc2=Duel.CreateToken(tp,_G["mhg"..num][time])
			Duel.SendtoHand(tc2,tp,REASON_RULE)
			time=time+1   
		end 
end
------------------------手卡
  local ehg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
   if #ehg~=0 and #ehg==#_G["ehg"..num] then
	local time=1 
	local tc=ehg:GetFirst() 
	while time<=#ehg and tc do
		if tc:GetOriginalCode()~=_G["ehg"..num][time] then
		   tc:SetEntityCode(_G["ehg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		end
		time=time+1
		tc=ehg:GetNext()
	end
  elseif #ehg>#_G["ehg"..num] then
	local time=1  
	local tc=ehg:GetFirst() 
	while time<=#ehg and tc do 
		if time<=#_G["ehg"..num] and tc:GetOriginalCode()~=_G["ehg"..num][time] then
		   tc:SetEntityCode(_G["ehg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#_G["ehg"..num] then
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		end
		time=time+1   
		tc=ehg:GetNext()
		end
  elseif #ehg<#_G["ehg"..num] and #ehg~=0 then
	local time=1 
	local tc=ehg:GetFirst() 
	while time<=#_G["ehg"..num]  do
		if time<=#ehg and tc:GetOriginalCode()~=_G["ehg"..num][time] then
		   tc:SetEntityCode(_G["ehg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#ehg then
			local tc2=Duel.CreateToken(tp,_G["ehg"..num][time])
			Duel.SendtoHand(tc2,1-tp,REASON_RULE)
		end
		time=time+1
		tc=ehg:GetNext()   
		end  
	elseif #ehg==0 and #_G["ehg"..num]~=0 then
		local time=1 
		while time<=#_G["ehg"..num]  do
			local tc2=Duel.CreateToken(tp,_G["ehg"..num][time])
			Duel.SendtoHand(tc2,1-tp,REASON_RULE)
			time=time+1   
		end 
end
-----------------------墓地
local mgg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
  if #mgg~=0 and #mgg==#_G["mgg"..num] then
	local time=1 
	local tc=mgg:GetFirst() 
	while time<=#mgg and tc do
		if tc:GetOriginalCode()~=_G["mgg"..num][time] then
		   tc:SetEntityCode(_G["mgg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		end
		time=time+1
		tc=mgg:GetNext()
	end
  elseif #mgg>#_G["mgg"..num] then
	local time=1  
	local tc=mgg:GetFirst() 
	while time<=#mgg and tc do 
		if time<=#_G["mgg"..num] and tc:GetOriginalCode()~=_G["mgg"..num][time] then
		   tc:SetEntityCode(_G["mgg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#_G["mgg"..num] then
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		end
		time=time+1   
		tc=mgg:GetNext()
		end
   elseif  #mgg~=0 and #mgg<#_G["mgg"..num] then
	local time=1 
	local tc=mgg:GetFirst() 
	while time<=#_G["mgg"..num]  do
		if time<=#mgg and tc:GetOriginalCode()~=_G["mgg"..num][time] then
		   tc:SetEntityCode(_G["mgg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#mgg then
			local tc2=Duel.CreateToken(tp,_G["mgg"..num][time])
			Duel.SendtoGrave(tc2,tp,REASON_RULE)
		end
		time=time+1
		tc=mgg:GetNext()   
		end  
   elseif #mgg==0 and #_G["mgg"..num]~=0 then
		local time=1 
		while time<=#_G["mgg"..num]  do
			local tc2=Duel.CreateToken(tp,_G["mgg"..num][time])
			Duel.SendtoGrave(tc2,tp,REASON_RULE)
			time=time+1   
		end  
end
------------------------墓地
   local egg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_GRAVE,nil)
   if #egg~=0 and #egg==#_G["egg"..num]  then
	local time=1 
	local tc=egg:GetFirst() 
	while time<=#egg and tc do
		if tc:GetOriginalCode()~=_G["egg"..num][time] then
		   tc:SetEntityCode(_G["egg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		end
		time=time+1
		tc=egg:GetNext()
	end
  elseif #egg>#_G["egg"..num] then
	local time=1  
	local tc=egg:GetFirst() 
	while time<=#egg and tc do 
		if time<=#_G["egg"..num] and tc:GetOriginalCode()~=_G["egg"..num][time] then
		   tc:SetEntityCode(_G["egg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#_G["egg"..num] then
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		end
		time=time+1   
		tc=egg:GetNext()
		end
  elseif #egg<#_G["egg"..num] and #egg~=0 then
	local time=1 
	local tc=egg:GetFirst() 
	while time<=#_G["egg"..num] do
		if time<=#egg and tc:GetOriginalCode()~=_G["egg"..num][time] then
		   tc:SetEntityCode(_G["egg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#egg then
			local tc2=Duel.CreateToken(tp,_G["egg"..num][time])
			Duel.SendtoGrave(tc2,1-tp,REASON_RULE)
		end
		time=time+1
		tc=egg:GetNext()   
		end  
   elseif #egg==0 and #_G["egg"..num]~=0 then
		local time=1 
		while time<=#_G["egg"..num]  do
			local tc2=Duel.CreateToken(tp,_G["egg"..num][time])
			Duel.SendtoGrave(tc2,1-tp,REASON_RULE)
			time=time+1   
	end
end
-----------------------除外
local mrg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
  if #mrg~=0 and #mrg==#_G["mrg"..num] then
	local time=1 
	local tc=mrg:GetFirst() 
	while time<=#mrg and tc do
		if tc:GetOriginalCode()~=_G["mrg"..num][time] then
			if _G["mBool"..num][time]==0 then
				tc:SetEntityCode(_G["mrg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
			else
				Duel.SendtoDeck(tc,0,-2,REASON_RULE)
				local tc2=Duel.CreateToken(tp,_G["mrg"..num][time])
				Duel.Remove(tc2,POS_FACEDOWN,REASON_RULE)
			end
		end
		time=time+1
		tc=mrg:GetNext()
	end
  elseif #mrg>#_G["mrg"..num] then
	local time=1  
	local tc=mrg:GetFirst() 
	while time<=#mrg and tc do 
		if time<=#_G["mrg"..num] and tc:GetOriginalCode()~=_G["mrg"..num][time] then
				if _G["mBool"..num][time]==0 then
					tc:SetEntityCode(_G["mrg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
				else
					Duel.SendtoDeck(tc,0,-2,REASON_RULE)
				local tc2=Duel.CreateToken(tp,_G["mrg"..num][time])
				Duel.Remove(tc2,POS_FACEDOWN,REASON_RULE)
			  end
		elseif time>#_G["mrg"..num] then
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		end
		time=time+1   
		tc=mrg:GetNext()
		end
  elseif #mrg<#_G["mrg"..num] and #mrg~=0 then
	local time=1 
	local tc=mrg:GetFirst()
	while time<=#_G["mrg"..num]  do
		if time<=#mrg and tc:GetOriginalCode()~=_G["mrg"..num][time] then
				if _G["mBool"..num][time]==0 then
				tc:SetEntityCode(_G["mrg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
				else
					Duel.SendtoDeck(tc,0,-2,REASON_RULE)
			   local tc2=Duel.CreateToken(tp,_G["mrg"..num][time])
			   Duel.Remove(tc2,POS_FACEDOWN,REASON_RULE)
			end
		elseif time>#mrg then
			if _G["mBool"..num][time]==0 then
			local tc2=Duel.CreateToken(tp,_G["mrg"..num][time])
			Duel.Remove(tc2,POS_FACEUP,REASON_RULE)
			else
			local tc2=Duel.CreateToken(tp,_G["mrg"..num][time])
			Duel.Remove(tc2,POS_FACEDOWN,REASON_RULE)
			end
		end
		time=time+1
		tc=mrg:GetNext()   
	end  
	elseif #mrg==0 and #_G["mrg"..num]~=0 then
		local time=1 
		while time<=#_G["mrg"..num]  do
			local tc2=Duel.CreateToken(tp,_G["mrg"..num][time])
			if _G["mBool"..num][time]==0 then
			Duel.Remove(tc2,POS_FACEUP,REASON_RULE)
			else
			Duel.Remove(tc2,POS_FACEDOWN,REASON_RULE)
			end
			time=time+1   
		end 
end
------------------------除外
 local erg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_REMOVED,nil)
  if #erg~=0 and #erg==#_G["erg"..num] then
	local time=1 
	local tc=erg:GetFirst() 
	while time<=#erg and tc do
		if tc:GetOriginalCode()~=_G["erg"..num][time] then
			if _G["eBool"..num][time]==0 then
				tc:SetEntityCode(_G["erg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
			else
				Duel.SendtoDeck(tc,0,-2,REASON_RULE)
				local tc2=Duel.CreateToken(1-tp,_G["erg"..num][time])
				Duel.Remove(tc2,POS_FACEDOWN,REASON_RULE)
			end
		end
		time=time+1
		tc=erg:GetNext()
	end
  elseif #erg>#_G["erg"..num] then
	local time=1  
	local tc=erg:GetFirst() 
	while time<=#erg and tc do 
		if time<=#_G["erg"..num] and tc:GetOriginalCode()~=_G["erg"..num][time] then
				if _G["eBool"..num][time]==0 then
					tc:SetEntityCode(_G["erg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
				else
					Duel.SendtoDeck(tc,0,-2,REASON_RULE)
				local tc2=Duel.CreateToken(1-tp,_G["erg"..num][time])
				Duel.Remove(tc2,POS_FACEDOWN,REASON_RULE)
			  end
		elseif time>#_G["erg"..num] then
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		end
		time=time+1   
		tc=erg:GetNext()
		end
  elseif #erg<#_G["erg"..num] and #erg~=0 then
	local time=1 
	local tc=erg:GetFirst() 
	while time<=#_G["erg"..num]  do
		if time<=#erg and tc:GetOriginalCode()~=_G["erg"..num][time] then
			if _G["eBool"..num][time]==0 then
			  tc:SetEntityCode(_G["erg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
			   else
			   Duel.SendtoDeck(tc,0,-2,REASON_RULE)
			   local tc2=Duel.CreateToken(1-tp,_G["erg"..num][time])
			   Duel.Remove(tc2,POS_FACEDOWN,REASON_RULE)
			end
		elseif time>#erg then
			if _G["eBool"..num][time]==0 then
			local tc2=Duel.CreateToken(1-tp,_G["erg"..num][time])
			Duel.Remove(tc2,POS_FACEUP,REASON_RULE)
			else
			local tc2=Duel.CreateToken(1-tp,_G["erg"..num][time])
			Duel.Remove(tc2,POS_FACEDOWN,REASON_RULE)
			 end
		end
		time=time+1
		tc=erg:GetNext()   
end 
		elseif #erg==0 and #_G["erg"..num]~=0 then
		local time=1 
		while time<=#_G["erg"..num]  do
			local tc2=Duel.CreateToken(1-tp,_G["erg"..num][time])
			if _G["eBool"..num][time]==0 then
			Duel.Remove(tc2,POS_FACEUP,REASON_RULE)
			else
			Duel.Remove(tc2,POS_FACEDOWN,REASON_RULE)
			end
			time=time+1   
		end  
end
-----------------------卡组
local mdg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
  if #mdg~=0 and #mdg==#_G["mdg"..num] then
	local time=1 
	local tc=mdg:GetFirst() 
	while time<=#mdg  and tc do
		if tc:GetOriginalCode()~=_G["mdg"..num][time] then
		   tc:SetEntityCode(_G["mdg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		end
		time=time+1
		tc=mdg:GetNext()
	end
  elseif #mdg>#_G["mdg"..num] then
	local time=1  
	local tc=mdg:GetFirst() 
	while time<=#mdg and tc do 
		if time<=#_G["mdg"..num] and tc:GetOriginalCode()~=_G["mdg"..num][time] then
		   tc:SetEntityCode(_G["mdg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#_G["mdg"..num] then
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		end
		time=time+1   
		tc=mdg:GetNext()
		end
  elseif #mdg<#_G["mdg"..num] and #mdg~=0 then
	local time=1 
	local tc=mdg:GetFirst() 
	while time<=#_G["mdg"..num] do
		if time<=#mdg and tc:GetOriginalCode()~=_G["mdg"..num][time] then
		   tc:SetEntityCode(_G["mdg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#mdg then
			local tc2=Duel.CreateToken(tp,_G["mdg"..num][time])
			Duel.SendtoDeck(tc2,tp,0,REASON_RULE)
		end
		time=time+1
		tc=mdg:GetNext()   
		end 
 elseif #mdg==0 and #_G["mdg"..num]~=0 then
		local time=1 
		while time<=#_G["mdg"..num]  do
			local tc2=Duel.CreateToken(tp,_G["mdg"..num][time])
			Duel.SendtoDeck(tc2,tp,0,REASON_RULE)
			time=time+1   
		end   
end
------------------------卡组
  local edg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_DECK,nil)
   if #edg~=0 and #edg==#_G["edg"..num] then
	local time=1 
	local tc=edg:GetFirst() 
	while time<=#edg and tc do
		if tc:GetOriginalCode()~=_G["edg"..num][time] then
		   tc:SetEntityCode(_G["edg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		end
		time=time+1
		tc=edg:GetNext()
	end
  elseif #edg>#_G["edg"..num] then
	local time=1  
	local tc=edg:GetFirst() 
	while time<=#edg and tc do 
		if time<=#_G["edg"..num] and tc:GetOriginalCode()~=_G["edg"..num][time] then
		   tc:SetEntityCode(_G["edg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#_G["edg"..num] then
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		end
		time=time+1   
		tc=edg:GetNext()
		end
  elseif #edg<#_G["edg"..num] and #edg~=0 then
	local time=1 
	local tc=edg:GetFirst() 
	while time<=#_G["edg"..num]  do
		if time<=#edg and tc:GetOriginalCode()~=_G["edg"..num][time] then
		   tc:SetEntityCode(_G["edg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
		elseif time>#edg then
			local tc2=Duel.CreateToken(tp,_G["edg"..num][time])
			 Duel.SendtoDeck(tc2,1-tp,0,REASON_RULE)
		end
		time=time+1
		tc=edg:GetNext()   
		end  
	elseif #edg==0 and #_G["edg"..num]~=0 then
		local time=1 
		while time<=#_G["edg"..num]  do
			local tc2=Duel.CreateToken(tp,_G["edg"..num][time])
			Duel.SendtoDeck(tc2,1-tp,0,REASON_RULE)
			time=time+1   
		end   
end
-----------------------额外
local mxg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_EXTRA,0,nil)
  if #mxg~=0 and #mxg==#_G["mxg"..num] then
	local time=1 
	local tc=mxg:GetFirst() 
	while time<=#mxg and tc do
		if tc:GetOriginalCode()~=_G["mxg"..num][time] then
			if _G["mxBool"..num][time]==1 then
				tc:SetEntityCode(_G["mxg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
			else
				Duel.SendtoDeck(tc,0,-2,REASON_RULE)
				local tc2=Duel.CreateToken(tp,_G["mxg"..num][time])
				Duel.SendtoExtraP(tc2,tp,REASON_RULE)
			end
		end
		time=time+1
		tc=mxg:GetNext()
	end
  elseif #mxg>#_G["mxg"..num] then
	local time=1  
	local tc=mxg:GetFirst() 
	while time<=#mxg and tc do 
		if time<=#_G["mxg"..num] and tc:GetOriginalCode()~=_G["mxg"..num][time] then
				if _G["mxBool"..num][time]==1 then
					tc:SetEntityCode(_G["mxg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
				else
				Duel.SendtoDeck(tc,0,-2,REASON_RULE)
				local tc2=Duel.CreateToken(tp,_G["mxg"..num][time])
				Duel.SendtoExtraP(tc2,tp,REASON_RULE)
			  end
		elseif time>#_G["mxg"..num] then
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		end
		time=time+1   
		tc=mxg:GetNext()
		end
  elseif #mxg<#_G["mxg"..num] and #mxg~=0 then
	local time=1 
	local tc=mxg:GetFirst()
	while time<=#_G["mxg"..num]  do
		if time<=#mxg and tc:GetOriginalCode()~=_G["mxg"..num][time] then
				if _G["mxBool"..num][time]==1 then
				tc:SetEntityCode(_G["mxg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
				else
				Duel.SendtoDeck(tc,0,-2,REASON_RULE)
			   local tc2=Duel.CreateToken(tp,_G["mxg"..num][time])
			   Duel.SendtoExtraP(tc2,tp,REASON_RULE)
			end
		elseif time>#mxg then
			if _G["mxBool"..num][time]==1 then
			local tc2=Duel.CreateToken(tp,_G["mxg"..num][time])
			Duel.SendtoDeck(tc2,tp,0,REASON_RULE)
			else
			local tc2=Duel.CreateToken(tp,_G["mxg"..num][time])
			Duel.SendtoExtraP(tc2,tp,REASON_RULE)
			end
		end
		time=time+1
		tc=mxg:GetNext()   
	end  
		elseif #mxg==0 and #_G["mxg"..num]~=0 then
		local time=1 
		while time<=#_G["mxg"..num]  do
			local tc2=Duel.CreateToken(tp,_G["mxg"..num][time])
			if _G["mxBool"..num][time]==1 then
			Duel.SendtoDeck(tc2,tp,0,REASON_RULE)
			else
			Duel.SendtoExtraP(tc2,tp,REASON_RULE)
			end
			time=time+1   
		end   
end
------------------------额外
 local exg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
  if #exg~=0 and #exg==#_G["exg"..num] then
	local time=1 
	local tc=exg:GetFirst() 
	while time<=#exg and tc do
		if tc:GetOriginalCode()~=_G["exg"..num][time] then
			if _G["exBool"..num][time]==1 then
				tc:SetEntityCode(_G["exg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
			else
				Duel.SendtoDeck(tc,0,-2,REASON_RULE)
				local tc2=Duel.CreateToken(tp,_G["exg"..num][time])
				Duel.SendtoExtraP(tc2,1-tp,REASON_RULE)
			end
		end
		time=time+1
		tc=exg:GetNext()
	end
  elseif #exg>#_G["exg"..num] then
	local time=1  
	local tc=exg:GetFirst() 
	while time<=#exg and tc do 
		if time<=#_G["exg"..num] and tc:GetOriginalCode()~=_G["exg"..num][time] then
				if _G["exBool"..num][time]==1 then
					tc:SetEntityCode(_G["exg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
				else
				Duel.SendtoDeck(tc,0,-2,REASON_RULE)
				local tc2=Duel.CreateToken(tp,_G["exg"..num][time])
				Duel.SendtoExtraP(tc2,1-tp,REASON_RULE)
			  end
		elseif time>#_G["exg"..num] then
			Duel.SendtoDeck(tc,0,-2,REASON_RULE)
		end
		time=time+1   
		tc=exg:GetNext()
		end
  elseif #exg<#_G["exg"..num] and #exg~=0 then
	local time=1
	local tc=exg:GetFirst() 
	while time<=#_G["exg"..num]  do
		if time<=#exg and tc:GetOriginalCode()~=_G["exg"..num][time] then
			if _G["exBool"..num][time]==1 then
			  tc:SetEntityCode(_G["exg"..num][time],nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true) 
			   else
			   Duel.SendtoDeck(tc,0,-2,REASON_RULE)
			   local tc2=Duel.CreateToken(tp,_G["exg"..num][time])
			   Duel.SendtoExtraP(tc2,1-tp,REASON_RULE)
			end
		elseif time>#exg then
			if _G["exBool"..num][time]==1 then
			local tc2=Duel.CreateToken(tp,_G["exg"..num][time])
			Duel.SendtoDeck(tc2,1-tp,0,REASON_RULE)
			else
			local tc2=Duel.CreateToken(tp,_G["exg"..num][time])
			  Duel.SendtoExtraP(tc2,1-tp,REASON_RULE)
			 end
		end
		time=time+1
		tc=exg:GetNext()   
end  
  elseif #exg==0 and #_G["exg"..num]~=0 then
		local time=1 
		while time<=#_G["exg"..num]  do
			local tc2=Duel.CreateToken(tp,_G["exg"..num][time])
			if _G["exBool"..num][time]==1 then
			Duel.SendtoDeck(tc2,1-tp,0,REASON_RULE)
			else
			Duel.SendtoExtraP(tc2,1-tp,REASON_RULE)
			end
			time=time+1   
		end   
end
Duel.SetLP(tp,_G["mhp"..num])
Duel.SetLP(1-tp,_G["ehp"..num])
Duel.ShuffleHand(tp)
Duel.ShuffleHand(1-tp)
------------------------------------------
end
	
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,5)
	s[e:GetHandler()]=e1
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then
		Duel.Win(1-tp,0x13)
		c:ResetFlagEffect(1082946)
	end
end 
	