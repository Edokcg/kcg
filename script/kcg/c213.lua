local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.recon2)
	e3:SetOperation(s.thop2)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_ASSAULT_MODE}

function s.recon2(e,tp,eg,ep,ev,re,r,rp)
    local rrealcode=e:GetHandler():GetRealCode()
	return not (re and re:GetHandler():IsCode(CARD_ASSAULT_MODE, 88332693)) and rrealcode<1
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and re:GetHandler():IsCode(CARD_ASSAULT_MODE, 88332693) then return end
	local announce_filter={TYPE_SYNCHRO, OPCODE_ISTYPE, OPCODE_ALLOW_ALIASES}
	local code=Duel.AnnounceCard(tp,table.unpack(announce_filter))
	local tc=Duel.CreateToken(tp,code)
    aux.burstop(tp,c,tc)aux.burstop(tp,tc,rg)
end