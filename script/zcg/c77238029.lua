--机械昆虫 金蝎(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 if aux.IsKCGScript then
			Fusion.AddProcMixN(c,true,true,77240487,1,s.ffilter,1)
	else
		aux.AddFusionProcCodeFun(c,77240487,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,true,true)
	end
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(s.atkval)
	c:RegisterEffect(e9)
	   --
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(s.efilter)
	c:RegisterEffect(e11)
end
function s.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te) and ec:GetControler()~=c:GetControler()
end
function s.atkval(e, c)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local atk=g:GetSum(Card.GetAttack)
	return math.ceil(atk)
end
function s.ffilter(c,fc,sub,sub2,mg,sg)
	return c:IsRace(RACE_MACHINE)
end