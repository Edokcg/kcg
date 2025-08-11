--大秘儀之力X-命運之輪 (KA)
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
s.listed_series={0x5}
s.listed_names={id}
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

	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)

	local e4=Effect.CreateEffect(c)

	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)

	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)

	e4:SetCode(EVENT_ADJUST)

	e4:SetRange(LOCATION_MZONE)

	e4:SetCondition(s.sdcon)

	e4:SetOperation(s.sdop)

	e4:SetReset(RESET_EVENT+0x1ff0000)

	c:RegisterEffect(e4)

	local e7=e4:Clone()

	e7:SetCode(EVENT_CHAIN_SOLVED)

	c:RegisterEffect(e7)

	local e8=e4:Clone()

	e8:SetCode(EVENT_SUMMON_SUCCESS)

	c:RegisterEffect(e8)

	local e9=e4:Clone()

	e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)

	c:RegisterEffect(e9)

	local e10=e4:Clone()

	e10:SetCode(EVENT_SPSUMMON_SUCCESS)

	c:RegisterEffect(e10)

end


function s.sdcon(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler() 

	local g=Duel.GetMatchingGroup(s.coin,0,LOCATION_MZONE,LOCATION_MZONE,c,e)

	return g:GetCount()>0

end

function s.sdop(e,tp,eg,ep,ev,re,r,rp)  

	local c=e:GetHandler()

	local val=c:GetFlagEffectLabel(36690018)  

	local val2=1-val

	local g=Duel.GetMatchingGroup(s.coin,0,LOCATION_MZONE,LOCATION_MZONE,c,e)

	local tc=g:GetFirst()

	while tc do

	tc:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,val2,63-val2)

	tc:RegisterFlagEffect(642,RESET_EVENT+0x1ff0000,0,1)

	tc=g:GetNext() end

end

function s.coin(c,e)

	return c:IsSetCard(0x5) and not c:IsCode(id)

	and c:IsFaceup() and c:GetFlagEffect(642)==0

	and not c:IsImmuneToEffect(e)

end