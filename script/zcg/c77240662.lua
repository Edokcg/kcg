--BT黑羽 神鸟王(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	if aux.IsKCGScript then
		Synchro.AddProcedure(c,s.tfilter2,1,1,Synchro.NonTuner(nil),3,99)
	else
		aux.AddSynchroProcedure(c,s.tfilter,aux.NonTuner(nil),3)
	end
	c:EnableReviveLimit()
  --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)
end
function s.tfilter2(c,scard,sumtype,tp)
	return c:IsSetCard(0x33,scard,sumtype,tp) or c:IsHasEffect(EFFECT_SYNSUB_NORDIC)
end
function s.tfilter(c)
	return c:IsSetCard(0x33) 
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.filter2(c)
	return  c:IsSetCard(0x33)  and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if Duel.Destroy(sg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		if Duel.IsPlayerCanDraw(tp,5) then
		   Duel.Draw(tp,5,REASON_EFFECT)
		   local rg=Duel.GetOperatedGroup()
		   local hg=rg:Filter(s.filter2,nil)
			if hg:GetCount()>0 then
				Duel.ConfirmCards(1-tp,hg)
				Duel.ShuffleHand(tp)
				local c=e:GetHandler()
				local ct=hg:GetCount()
				if ct>1 then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EXTRA_ATTACK)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					e1:SetValue(ct-1)
					c:RegisterEffect(e1)
				elseif ct==0 then
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_CANNOT_ATTACK)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					c:RegisterEffect(e2)
				end
			end
		end
	end
end








