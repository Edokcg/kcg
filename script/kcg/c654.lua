local s,id=GetID()
function s.initial_effect(c)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(s.spcondition)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)
end    
s.listed_names={41418852,612}

function s.spcondition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function s.damfilter(c)
	return c:IsFaceup() and c:IsCode(41418852)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if g~=nil and s.damfilter(g) then	
    g:RegisterFlagEffect(602,RESET_EVENT+0x1fe0000,0,1) end
end