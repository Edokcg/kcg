--大秘儀之力XI-正義 (KA)
local s,id=GetID()
function s.initial_effect(c)

	 --coin

	local e1=Effect.CreateEffect(c)

	e1:SetDescription(aux.Stringid(8396952,0))

	e1:SetCategory(CATEGORY_COIN)

	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)

	e1:SetCode(EVENT_SUMMON_SUCCESS)

	e1:SetTarget(s.cointg)

	e1:SetOperation(s.coinop)

	c:RegisterEffect(e1)

	local e2=e1:Clone()

	e2:SetCode(EVENT_SPSUMMON_SUCCESS)

	c:RegisterEffect(e2)

	local e3=e1:Clone()

	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)

	c:RegisterEffect(e3)
end
s.toss_coin=true

function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then return true end

	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)

end

function s.coinop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()

	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end

	local res=0

	if c:IsHasEffect(73206827) then

		res=1-Duel.SelectOption(tp,60,61)

	else res=Duel.TossCoin(tp,1) end

	s.arcanareg(c,res)

end

function s.arcanareg(c,coin)

	--cannot attack

	local e1=Effect.CreateEffect(c)

	e1:SetType(EFFECT_TYPE_SINGLE)

	e1:SetCode(EFFECT_ATTACK_ALL)

	e1:SetValue(s.atkfilter)

	e1:SetReset(RESET_EVENT+0x1ff0000)

	c:RegisterEffect(e1)


	--cannot attack

	local e3=Effect.CreateEffect(c)

	e3:SetType(EFFECT_TYPE_FIELD)

	e3:SetRange(LOCATION_MZONE)

	e3:SetTargetRange(0,LOCATION_MZONE)

	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)

	e3:SetTarget(s.tga)

	e3:SetValue(s.vala)

	e3:SetReset(RESET_EVENT+0x1ff0000)

	c:RegisterEffect(e3)


	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)

end


function s.atkfilter(e,c)

	local tc=e:GetHandler()

	local val=tc:GetFlagEffectLabel(36690018)

	return val==1 and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL

end

function s.tga(e,c)

	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=SUMMON_TYPE_SPECIAL

end

function s.vala(e,c)

	local tc=e:GetHandler()

	local val=tc:GetFlagEffectLabel(36690018)

	return c==e:GetHandler() and val==0

end