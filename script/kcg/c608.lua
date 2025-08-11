--光の結界
function c608.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c608.cointg)
	e1:SetOperation(c608.coinop)
	c:RegisterEffect(e1)

	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73206827,0))
	e2:SetCategory(CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c608.coincon)
	e2:SetTarget(c608.cointg)
	e2:SetOperation(c608.coinop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(73206827)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5))
	e3:SetCondition(c608.effectcon)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(73206827,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c608.reccon)
	e4:SetTarget(c608.rectg)
	e4:SetOperation(c608.recop)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c608.distg)
	e5:SetCondition(c608.effectcon)
	c:RegisterEffect(e5)
			local e6=e5:Clone()
	e6:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e6)
end

function c608.coincon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c608.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c608.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		if Duel.GetCurrentPhase()==PHASE_STANDBY then c:RegisterFlagEffect(73206828,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
						else c:RegisterFlagEffect(73206828,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1) end
	end
end

function c608.effectcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(73206828)==0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE)
end

function c608.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsSetCard(0x5) and rc:IsFaceup() 
		and (c:GetFlagEffect(73206828)==0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE))
end
function c608.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst():GetBattleTarget()
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
	Duel.SetTargetPlayer(eg:GetFirst():GetControler())
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,eg:GetFirst():GetControler(),atk)
end
function c608.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

function c608.distg(e,c)
	return not c:IsSetCard(0x5)
end
