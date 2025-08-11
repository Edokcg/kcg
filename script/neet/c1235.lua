--真帝王的邪怨(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)	
end
function s.filter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_TRIBUTE) and c:IsAttackAbove(2400) and c:IsDefense(1000) and Duel.IsPlayerCanDraw(tp,c:GetMaterialCount()) and c:GetMaterialCount()>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.filter,1,false,nil,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupCost(tp,filter,1,1,false,nil,nil,tp)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	e:SetLabel(g:GetFirst():GetMaterialCount())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,d) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(d)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,d)
end
function s.nfilter(c,att)
	return not c:IsAttribute(att)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(s.nfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end