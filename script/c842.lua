--
local s,id=GetID()
local RSelecl=Group.RandomSelect
function Group.RandomSelect(g,p,ct)
	if Duel.HasFlagEffect(p,id) then
		local sg=g:Filter(Card.IsControler,nil,1-p)
		if #sg>0 then
			Duel.ConfirmCards(p,sg)
		end
		return g:Select(p,ct,ct,nil)
	end
	return RSelecl(g,p,ct) 
end
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(0xff)
	e1:SetCode(EVENT_STARTUP)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)	
	Duel.RegisterFlagEffect(tp,id,0,0,1)
end