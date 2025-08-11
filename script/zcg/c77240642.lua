--奥利哈刚 金斧牛战将(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--fusion material
	c:EnableReviveLimit()
	if aux.IsKCGScript then
		Fusion.AddProcCode2(c,77240634,77240632,true,true)
	else
		aux.AddFusionProcCode2(c,77240634,77240632,true,true)
	end
--Activate
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(id,0))
	e99:SetType(EFFECT_TYPE_IGNITION)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCountLimit(1)
	e99:SetTarget(s.destg)
	e99:SetOperation(s.desop)
	c:RegisterEffect(e99)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) and  Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp)  end
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.filter2(c,level)
	return c:IsLevelBelow(level) and c:IsFaceup()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
		g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_ONFIELD,0,nil)
		tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
		Duel.BreakEffect()
		local gg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,gg)
		gg=gg:Select(tp,1,1,nil)
		Duel.ConfirmCards(tp,gg)
		Duel.ConfirmCards(1-tp,gg)
		local ttc=gg:GetFirst()
		local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
		if ttc:IsType(TYPE_SPELL+TYPE_TRAP) and #sg>0 then
			   Duel.Destroy(sg,REASON_EFFECT)
		elseif ttc:IsType(TYPE_MONSTER) then
				local mg=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,nil,ttc:GetLevel())
				if #mg<=0 then return end
				Duel.Destroy(mg,REASON_EFFECT)
		end
	end
end



