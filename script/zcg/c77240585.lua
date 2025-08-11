--殉道者之厄运相连(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetTarget(s.rectg1)
	e2:SetOperation(s.recop1)
	c:RegisterEffect(e2)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(s.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e12:SetTarget(s.distg9)
	c:RegisterEffect(e12)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.rectg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return rp==1-tp  and tc and tc:GetAttribute()~=nil end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	 local atk=e:GetHandler():GetAttack()/2
	 Duel.Damage(tp,atk,REASON_EFFECT)
end
function s.recop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local c=e:GetHandler()
	if tc:IsAttribute(ATTRIBUTE_DARK) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
	end
	if tc:IsAttribute(ATTRIBUTE_LIGHT) then
		local de=Effect.CreateEffect(c)
		de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		de:SetRange(LOCATION_MZONE)
		de:SetCode(EVENT_PHASE+PHASE_STANDBY)
		de:SetCountLimit(1)
		de:SetOperation(s.desop)
		tc:RegisterEffect(de,true)
	end
	if tc:IsAttribute(ATTRIBUTE_WATER) then
	   local mg=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil) 
		local tc2=mg:GetFirst()
		while tc2 do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc2:RegisterEffect(e2)
			tc2=mg:GetNext()
		end
	end
	if tc:IsAttribute(ATTRIBUTE_FIRE) and Duel.IsPlayerCanDraw(tp,2) then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	if tc:IsAttribute(ATTRIBUTE_WIND) then
	 Duel.Recover(tp,1000,REASON_EFFECT)
	end
	 if tc:IsAttribute(ATTRIBUTE_EARTH) then
	   local mg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_HAND,0,2,2,nil)
		Duel.SendtoGrave(mg,REASON_DISCARD+REASON_EFFECT)
	end
	if tc:IsAttribute(ATTRIBUTE_DIVINE) then
		 Duel.NegateSummon(eg)
		 Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function s.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end