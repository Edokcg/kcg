--混沌上升
function c276.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8387138,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c276.con)
	e1:SetTarget(c276.target)
	e1:SetOperation(c276.activate)
	c:RegisterEffect(e1)
end

function c276.con(e,tp,eg,ep,ev,re,r,rp)
	local atker=Duel.GetAttacker()
	local a=Duel.GetBattleDamage(tp)
	return ep==tp and atker~=nil and atker:IsSetCard(0x1048) and atker:GetControler()==1-e:GetHandler():GetControler() and a>=2000
end
function c276.filter1(c,e,tp)
	return c:IsSetCard(0x1048) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) 
end
function c276.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) 
		and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>2
		and aux.CheckSummonGate(tp,3)
		and Duel.IsExistingMatchingCard(c276.filter1,tp,LOCATION_EXTRA,0,3,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_EXTRA)
end
function c276.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or not aux.CheckSummonGate(tp,3) then return end
	local g=Duel.GetMatchingGroup(c276.filter1,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then
		g=g:RandomSelect(tp,3) 
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		tc=g:GetFirst()
		while tc do
			tc:CompleteProcedure()
			tc=g:GetNext() 
		end
	end
end
