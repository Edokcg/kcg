--精霊の鏡
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c:GetFlagEffect(id)==0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local c=e:GetHandler()
		c:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000,0,1)
		local te2 = re:Clone()
		local tg = re:GetTarget()
		local op = re:GetOperation()
		te2:SetRange(LOCATION_SZONE)
		if bit.band(re:GetType(), EFFECT_TYPE_ACTIVATE) ~= 0 then
            if re:GetCode()==EVENT_CHAINING or re:GetCode()==EVENT_FREE_CHAIN then
                te2:SetType(EFFECT_TYPE_QUICK_O)
            else
                te2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
            end
		end
		te2:SetReset(RESET_EVENT+0x1fe0000)
		te2:SetTarget(function (ae,atp,aeg,aep,aev,are,ar,arp,chk)
			if chk==0 then return ae:GetHandler():GetFlagEffect(id+1)==0 and (not tg or tg(ae,atp,aeg,aep,aev,are,ar,arp,0)) end
			if tg then tg(ae,atp,aeg,aep,aev,are,ar,arp) end
			ae:GetHandler():RegisterFlagEffect(id+1,RESET_EVENT+0x1fe0000,0,1)
		end)
		te2:SetOperation(function (ae,atp,aeg,aep,aev,are,ar,arp)
			if op then
				op(ae,atp,aeg,aep,aev,are,ar,arp)
			end
			Duel.Destroy(ae:GetHandler(),REASON_RULE)
		end)
		c:RegisterEffect(te2, true)
	end
end