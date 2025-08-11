--大秘儀之力XVII-星星 (KA)
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

	local e1=Effect.CreateEffect(c)

	e1:SetDescription(aux.Stringid(983995,0))

	e1:SetCategory(CATEGORY_DRAW)

	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)

	e1:SetCode(EVENT_SUMMON_SUCCESS)

	e1:SetTarget(s.drtg)

	e1:SetOperation(s.drop)

	e1:SetReset(RESET_EVENT+0x1ff0000)

	c:RegisterEffect(e1)

	local e01=e1:Clone()

	e01:SetTarget(s.drtg2)

	e01:SetOperation(s.drop2)

	c:RegisterEffect(e01)

	local e2=e1:Clone()

	e2:SetCode(EVENT_SPSUMMON_SUCCESS)

	c:RegisterEffect(e2)
	local e02=e2:Clone()

	e02:SetTarget(s.drtg2)

	e02:SetOperation(s.drop2)

	c:RegisterEffect(e02)

	local e3=e1:Clone()

	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)

	c:RegisterEffect(e3)

	local e03=e3:Clone()

	e03:SetTarget(s.drtg2)

	e03:SetOperation(s.drop2)

	c:RegisterEffect(e03)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end


function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local val=c:GetFlagEffectLabel(36690018) 
	if chk==0 then return val==1 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function s.dr(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local val=c:GetFlagEffectLabel(36690018) 
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() and chkc:IsControler(tp) and s.dr(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.dr,tp,LOCATION_GRAVE,0,1,nil) and val==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.dr,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.drop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
end