local s, id = GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition) 
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e19=Effect.CreateEffect(c)
	e19:SetType(EFFECT_TYPE_FIELD)
	e19:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e19:SetCode(EFFECT_SANCT)
	e19:SetRange(LOCATION_FZONE)
	e19:SetTargetRange(1,0)
	c:RegisterEffect(e19)
	
	--维持代价
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.mtcon)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)

	--重置怨灵
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.mtcon1)
	e4:SetOperation(s.mtop1)
	c:RegisterEffect(e4)
	
	--补充怨灵
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.mtcon2)
	e5:SetOperation(s.activate)
	c:RegisterEffect(e5)
	  	
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DISABLE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCondition(s.condition2)
	c:RegisterEffect(e7)

	--不会被卡的效果破坏、除外、返回手牌和卡组
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(s.efilterr)
	c:RegisterEffect(e6)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
	e9:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e9)
	local e10=e6:Clone()
	e10:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e10)
	local e104=e6:Clone()
	e104:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e104)
	local e105=e6:Clone()
	e105:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e105)
	local e106=e6:Clone()
	e106:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e106)
	local e107=e6:Clone()
	e107:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e107)
	local e108=e6:Clone()
	e108:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e108)  
	local e109=e6:Clone()
	e109:SetCode(EFFECT_CANNOT_USE_AS_COST)
	c:RegisterEffect(e109)
	local e111=e6:Clone()
	e111:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e111)
end
s.listed_names={31829185,812}
----------------------------------------------------------------------
function s.cfilter(c)
	return c:IsCode(31829185)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then
		local token=Duel.CreateToken(1-tp,812)
		if not Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then return end
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsFaceup() then
			s.activate2(e,tp,token,tc)
		end
	end
end
function s.activate2(e,tp,token,tc)
	Duel.RaiseEvent(Group.FromCards(token,tc),EVENT_EQUIP,e,REASON_EFFECT,tp,tp,0)
	local e1=Effect.CreateEffect(token)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(810)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)	
	tc:RegisterEffect(e1,true)   
	--攻击无效
	local e6=Effect.CreateEffect(token)
	e6:SetDescription(aux.Stringid(36378044,0))
	e6:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetLabel(1)
	e6:SetCondition(s.atkcon)
	e6:SetOperation(s.atkop)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)  
	tc:RegisterEffect(e6)  
	local e2=Effect.CreateEffect(token)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(function(ae) e1:Reset() ae:Reset() end)
	token:RegisterEffect(e2,true)   
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHANGE_POS)  
	token:RegisterEffect(e3,true)   
	local e4=Effect.CreateEffect(token)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(function(ae) Duel.Destroy(token,REASON_RULE) end)
	--e4:SetReset(RESET_EVENT+RESETS_STANDARD)  
	tc:RegisterEffect(e4,true)  
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHANGE_POS)  
	e5:SetCondition(function(...) return tc:IsFacedown() end)
	--e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET) 
	tc:RegisterEffect(e5,true)  
	--Duel.Hint(HINT_CARD,tp,tc:GetCode())--确认
	--Duel.ConfirmCards(tp,tc)--确认
end
----------------------------------------------------------------------
local equipg=Card.GetEquipGroup
function Card.GetEquipGroup(c)
	local token=Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_SZONE,LOCATION_SZONE,nil,812)
	local tg=Duel.GetFirstMatchingCard(Card.IsHasEffect,0,LOCATION_MZONE,LOCATION_MZONE,nil,810)
	local mg=equipg(c)
	mg:Merge(token)
	return mg
end
local equipgc=Card.GetEquipCount
function Card.GetEquipCount(c)
	return c:GetEquipGroup():GetCount()
end
local equiptg=Card.GetEquipTarget
function Card.GetEquipTarget(c)
	local token=Duel.GetFirstMatchingCard(Card.IsCode,0,LOCATION_SZONE,LOCATION_SZONE,nil,812)
	local tg=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_MZONE,LOCATION_MZONE,nil,810)
	if c==token and tg:GetCount()>0 then return tg:GetFirst()
	else return equiptg(c) end
end
----------------------------------------------------------------------
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckReleaseGroup(tp,nil,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(78371393,2)) then
		local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
		Duel.Release(g,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
----------------------------------------------------------------------
function s.mtcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_SZONE,LOCATION_SZONE,nil,812)>0 and Duel.IsExistingMatchingCard(Card.IsFaceup, 0, LOCATION_MZONE, 0, 1, nil)
end
function s.mtop1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_SZONE,LOCATION_SZONE,nil,812)
	if token==nil then return end
	local g=token:GetEquipTarget()
	if g~=nil then
	aux.ResetEffects(Group.FromCards(g),810) end
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g2:GetCount()>0 then
		local sg=g2:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsFaceup() then
		s.activate2(e,tp,token,tc) end
	end
end
----------------------------------------------------------------------
function s.filter2(c)
	return c:IsHasEffect(810)
end
function s.mtcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_SZONE,LOCATION_SZONE,nil,812)==0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
end
----------------------------------------------------------------------
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetAttacker()
	return tg:IsHasEffect(810)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if not tc:IsImmuneToEffect(e) and Duel.NegateAttack() then
		Duel.Damage(tc:GetControler(),tc:GetAttack()/2,REASON_EFFECT)
		Duel.Recover(1-tc:GetControler(),tc:GetAttack()/2,REASON_EFFECT)
	end
end

function s.qfilter(c)
	return not c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL+TYPE_TRAP)
	  --and c:GetActivateEffect() 
	  and c:GetFlagEffect(511000120)==0 and not c:IsHasEffect(EFFECT_CANNOT_SSET)
end
function s.activ(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.qfilter,tp,LOCATION_HAND,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(511000120)==0 then
			local tpe=tc:GetType()
			local te=tc:GetActivateEffect()
			local condition=te:GetCondition()
			local property=te:GetProperty()
			local cost=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			--move
			local e15=Effect.CreateEffect(c)
			e15:SetDescription(te:GetDescription())
			e15:SetType(EFFECT_TYPE_FIELD)
			if property then
			e15:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+property)
			else e15:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE) end
			e15:SetCode(EFFECT_SPSUMMON_PROC_G)
			e15:SetRange(LOCATION_HAND)
			e15:SetCondition(function(ae,...) 
			   return Duel.GetLocationCount(ae:GetHandlerPlayer(),LOCATION_MZONE)>0 
				 and (con==nil or con(ae,...)) 
			end)
			if cost then e15:SetCost(cost) end
			e15:SetTarget(function(ae,atp,aeg,aep,aev,are,ar,arp,chk) 
			   if chk==0 then return (tg==nil or tg(ae,atp,aeg,aep,aev,are,ar,arp,0)) end
			   Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			   if tg then 
				 Duel.MoveToField(ae:GetHandler(),atp,atp,LOCATION_MZONE,POS_FACEUP_ATTACK,true) 
				 tg(ae,atp,aeg,aep,aev,are,ar,arp,1,nil) end 
			end) 
			e15:SetOperation(function(ae,atp,aeg,aep,aev,are,ar,arp) 
			   if not ae:GetHandler():IsLocation(LOCATION_SZONE) then 
			   Duel.MoveToField(ae:GetHandler(),atp,atp,LOCATION_MZONE,POS_FACEUP_ATTACK,true) end
			   if op then op(ae,atp,aeg,aep,aev,are,ar,arp) end  
			   ae:GetHandler():RegisterFlagEffect(810,0,0,1)
			   local e16=Effect.CreateEffect(ae:GetHandler())
			   e16:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			   e16:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			   e16:SetCode(EVENT_LEAVE_FIELD) 
			   e16:SetOperation(function(ae) ae:GetHandler():ResetFlagEffect(810) ae:Reset() end)
			   ae:GetHandler():RegisterEffect(e16,true)
			end)
			--tc:RegisterEffect(e15,true)
			local e5=Effect.CreateEffect(c)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE) 
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetCode(EFFECT_SPSUMMON_PROC_G)
			e5:SetRange(LOCATION_HAND)
			e5:SetReset(RESET_EVENT+0x1fe0000)
			e5:SetCondition(function(ae,...) 
			   return Duel.GetLocationCount(ae:GetHandlerPlayer(),LOCATION_MZONE)>0 
			end)
			e5:SetOperation(function(ae,atp,aeg,aep,aev,are,ar,arp) 
			   if not Duel.MoveToField(ae:GetHandler(),atp,atp,LOCATION_MZONE,POS_FACEDOWN_ATTACK,true) then return end
			   ae:GetHandler():RegisterFlagEffect(810,0,0,1)
			   local e16=Effect.CreateEffect(ae:GetHandler())
			   e16:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			   e16:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			   e16:SetCode(EVENT_LEAVE_FIELD) 
			   e16:SetOperation(function(be) be:GetHandler():ResetFlagEffect(810) ae:Reset() end)
			   ae:GetHandler():RegisterEffect(e16,true)
			end)
			tc:RegisterEffect(e5,true)
			tc:RegisterFlagEffect(511000120,RESET_EVENT+RESETS_STANDARD,0,1)
			local e16=Effect.CreateEffect(c)
			e16:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e16:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e16:SetCode(EVENT_LEAVE_FIELD) 
			e16:SetOperation(function(ae) e5:Reset() tc:ResetFlagEffect(511000120) ae:Reset() end)
			c:RegisterEffect(e16,true)
			local e17=e16:Clone()
			e17:SetCode(EVENT_CONTROL_CHANGED)  
			c:RegisterEffect(e17,true)  
			local e18=e16:Clone()
			e18:SetCode(EVENT_CHANGE_POS)  
			c:RegisterEffect(e18,true) 
		end
	end  
end

function s.efilterr(e,te)
	return te:GetOwner()~=e:GetOwner()
end