--变异体 秘异三变联体
function c1624.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	Fusion.AddProcFun2(c,c1624.matfilter1,c1624.matfilter2,true)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1624,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,1624)
	e1:SetCondition(c1624.lmcon)
	e1:SetCost(c1624.lmcost)
	e1:SetOperation(c1624.lmop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1624,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1624+100)
	e2:SetCondition(c1624.drcon)
	e2:SetTarget(c1624.drtg)
	e2:SetOperation(c1624.drop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1624,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,1624+200)
	e3:SetCondition(c1624.thcon)
	e3:SetTarget(c1624.thtg)
	e3:SetOperation(c1624.thop)
	c:RegisterEffect(e3)
end
-------------------------------
function c1624.matfilter1(c)
	return c:IsFusionSetCard(0x159) and c:IsLevel(8)
end
function c1624.matfilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_PSYCHIC)
end
-------------------------------
function c1624.lmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c1624.costfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToRemoveAsCost()
end
function c1624.lmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1624.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,c1624.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	e:SetLabel(cost:GetType())
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
end
function c1624.lmop(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabel()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1) 
	if typ&TYPE_MONSTER>0 then
		e1:SetDescription(aux.Stringid(1624,3))
		e1:SetValue(c1624.aclimit1)
	elseif typ&TYPE_SPELL>0 then
		e1:SetDescription(aux.Stringid(1624,4))
		e1:SetValue(c1624.aclimit2)
	else
		e1:SetDescription(aux.Stringid(1624,5))
		e1:SetValue(c1624.aclimit3)
	end
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e1,tp)
end
function c1624.aclimit1(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard(0x159)
end
function c1624.aclimit2(e,re,tp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not rc:IsSetCard(0x159)
end
function c1624.aclimit3(e,re,tp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and not rc:IsSetCard(0x159)
end
-------------------------------
function c1624.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x159) and c:IsControler(tp) and c:IsPreviousControler(tp)
end
function c1624.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1624.cfilter,1,nil,tp)
end
function c1624.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1624.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
-------------------------------
function c1624.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c1624.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x159) and c:IsFaceup()
end
function c1624.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1624.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c1624.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1624.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
