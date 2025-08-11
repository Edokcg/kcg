-- The Advanced Seal Of Orichalcos
-- local iscode=Card.IsCode
-- function Card.IsCode(c, code1, code2,...)
-- 	local g=c:GetOverlayGroup()
-- 	if c:GetOriginalCode()==12201 and #g>0 and not c:IsDisabled() and c:IsFaceup() and c:IsLocation(LOCATION_FZONE) and not iscode(c, code1, code2,...) then
-- 		for tc in aux.Next(g) do
-- 			if iscode(tc, code1, code2,...) then return true end
-- 		end
-- 	end
-- 	return iscode(c, code1, code2,...)
-- end

local s, id = GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.actg) 
	c:RegisterEffect(e1)
	
	local e000=Effect.CreateEffect(c)
	e000:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SINGLE_RANGE)
	e000:SetType(EFFECT_TYPE_SINGLE)
	e000:SetRange(LOCATION_FZONE)
	e000:SetCode(EFFECT_ULTIMATE_IMMUNE)
	c:RegisterEffect(e000) 

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(s.efilterr)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e7)
	local e104=e4:Clone()
	e104:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e104)
	local e105=e4:Clone()
	e105:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e105)
	local e106=e4:Clone()
	e106:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e106)
	local e107=e4:Clone()
	e107:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e107)
	local e108=e4:Clone()
	e108:SetCode(EFFECT_IMMUNE_EFFECT)
	--e108:SetValue(s.efilterr) 
	c:RegisterEffect(e108)  
	local e109=e4:Clone()
	e109:SetCode(EFFECT_CANNOT_USE_AS_COST)
	c:RegisterEffect(e109)
	local e111=e4:Clone()
	e111:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e111)

	--场上存在时不能发动场地魔法卡
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(1,0)
	e8:SetValue(s.distg)
	c:RegisterEffect(e8)
	
	--场上存在时不能放置场地魔法卡
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_SSET)
	e10:SetRange(LOCATION_FZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e10:SetTargetRange(1,0)
	e10:SetTarget(s.sfilter)
	c:RegisterEffect(e10)	

	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(s.sdcon2)
	e5:SetOperation(s.sdop)
	c:RegisterEffect(e5) 

	local ge2=Effect.CreateEffect(c)
    ge2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_ZERO_LP)
	ge2:SetRange(LOCATION_FZONE)	
	ge2:SetOperation(s.op)
	c:RegisterEffect(ge2)

	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_PLAYER_TARGET)
	e18:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	e18:SetRange(LOCATION_FZONE)
	e18:SetTargetRange(1,0)
	e18:SetCondition(s.lpcon)
	e18:SetValue(1)
	c:RegisterEffect(e18) 
	local e19=e18:Clone()  
	e19:SetCode(EFFECT_CANNOT_LOSE_DECK)	
	c:RegisterEffect(e19) 	
	local e20=e18:Clone()  
	e20:SetCode(EFFECT_CANNOT_LOSE_LP)
	c:RegisterEffect(e20) 	

	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12744567,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)	
end

function s.atcon(e)
	local tc=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)
	local tc2=Duel.GetFieldCard(1-e:GetHandler():GetControler(),LOCATION_SZONE,5)
	if tc~=nil and tc:IsFaceup() and tc:IsCode(110000101) and tc2~=nil and tc2:IsFaceup() and tc2:IsCode(110000101) and (Duel.GetTurnCount()==tc:GetTurnID() or Duel.GetTurnCount()==tc2:GetTurnID()) then return false end
	return (tc~=nil and tc:IsFaceup() and tc:IsCode(110000101) and Duel.GetTurnCount()~=tc:GetTurnID())
	or (tc2~=nil and tc2:IsFaceup() and tc2:IsCode(110000101) and Duel.GetTurnCount()~=tc2:GetTurnID())
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end

function s.efilterr(e, te)
	return te and not (te:GetOwner()==e:GetOwner() or te:GetOwner():IsSetCard(0x900))
end

function s.distg(e, te, tp)
    return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_FIELD) and not te:GetOwner():IsSetCard(0x900)
end

function s.sfilter(e, c, tp)
    return c:IsType(TYPE_FIELD) and Duel.GetFieldCard(c:GetControler(), LOCATION_SZONE, 5) ~= nil and c ~=
               e:GetHandler()
end

function s.specfilter(c)
	return c:IsFaceup() and c:IsCode(574)
end
function s.speccon(e)
	return Duel.IsExistingMatchingCard(s.specfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end

function s.lpcon(e)
	return e:GetHandler():GetOverlayCount()>0
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.actcondition(e,c)
	local c=e:GetHandler()
	local a,aeg,aep,aev,are,ar,arp=Duel.CheckEvent(317,true)
	return (a and s.condition2(e,e:GetHandlerPlayer(),aeg,aep,aev,are,ar,arp) and s.target(e,e:GetHandlerPlayer(),aeg,aep,aev,are,ar,arp,0) and c:GetFlagEffect(317)==0)
	or (c:GetFlagEffect(317)~=0)
	or (Duel.CheckEvent(EVENT_BATTLE_DAMAGE) and Duel.GetBattleDamage(e:GetHandlerPlayer())>0 and Duel.GetLP(e:GetHandlerPlayer())==0 and c:GetFlagEffect(317)==0) 
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0 and Duel.GetLP(tp)==0
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(317,RESET_CHAIN,0,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLP(tp)<4000 then Duel.SetLP(tp,4000) end
end

function s.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local g=c:GetOverlayGroup()
	local count=0	
	if g:GetCount()>0 then
		count=g:GetClassCount(Card.GetOriginalCode)
	end
	local eff={c:IsHasEffect(12201)}
	return #eff~=count and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local count=0
	if g:GetCount()>0 then
		count=g:GetClassCount(Card.GetOriginalCode)
	end
	local eff={c:IsHasEffect(12201)}
	if #eff<count then
	  for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		for _,ef in ipairs(eff) do
			if ef:GetValue()==code then goto continue end
		end
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000,0,1)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_INCLUDE_CODE)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e7:SetValue(function(ae) return tc:GetCode() end)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e7)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(12201)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(cid)
		e1:SetLabelObject(e7)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	    ::continue::
	  end
	else
	  local eff2={}
	  for _,ef in ipairs(eff) do
		for tc in aux.Next(g) do
			local code=tc:GetOriginalCode()	
			if ef:GetValue()==code then goto continue2 end
		end
		table.insert(eff2,ef)
	    ::continue2::
	  end
	  for _,ef in ipairs(eff2) do 
		c:ResetEffect(ef:GetLabel(),RESET_COPY)
		ef:GetLabelObject():Reset()
		ef:Reset()
	  end 
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount() > 0 then
		c:RemoveOverlayCard(tp,1,1,REASON_RULE)
		Duel.SetLP(tp,4000)
	end
end	

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE) 
	local tc=Duel.AnnounceCard(tp,TYPE_CONTINUOUS,OPCODE_ISTYPE,TYPE_FIELD,OPCODE_ISTYPE,OPCODE_OR,TYPE_SPELL,OPCODE_ISTYPE,OPCODE_AND,TYPE_TOKEN,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND,OPCODE_ALLOW_ALIASES)
	if tc then
		local token=Duel.CreateToken(tp,tc)
		Duel.Remove(token,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Overlay(c,token)	
	end
end