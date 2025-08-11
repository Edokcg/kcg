--上古独眼巨人(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--immue 
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD)
	e17:SetCode(EFFECT_IMMUNE_EFFECT)
	e17:SetRange(LOCATION_MZONE)
	e17:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e17:SetTarget(s.tger)
	e17:SetValue(s.efilter)
	c:RegisterEffect(e17)
	local e18=e17:Clone()
	e18:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e18:SetValue(s.indes)
	c:RegisterEffect(e18)
  --destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(s.reptg)
	e4:SetValue(s.repval)
	e4:SetOperation(s.repop)
	c:RegisterEffect(e4)
end
function s.refilter(c,tp)
return c:IsReason(REASON_EFFECT) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xa120) and not c:IsReason(REASON_REPLACE)
	   and c:GetControler(tp)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:Filter(s.refilter,e:GetHandler(),tp)  and rp==1-tp end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.repval(e,c)
	return s.refilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and Duel.IsPlayerCanSpecialSummonMonster(tp,77240389,0x1111,0x1111,2000,2000,1,RACE_FIEND,ATTRIBUTE_DARK) then
			local token=Duel.CreateToken(tp,77240389)
			local token2=Duel.CreateToken(tp,77240389)
			local g=Group.CreateGroup()
			g:AddCard(token)
			g:AddCard(token2)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)   
	  end
end
function s.indes(e,c)
	return not (c:IsSetCard(0xa120) and c:IsType(TYPE_MONSTER))
end
function s.tger(e,c)
	return c:IsSetCard(0xa120)
end
function s.efilter(e,te)
	return not te:GetOwner():IsSetCard(0xa120) and te:IsActiveType(TYPE_MONSTER)
end