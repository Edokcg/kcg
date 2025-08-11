--时间魔道士(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon Procedure
	Synchro.AddProcedure(c,nil,1,1,aux.FilterSummonCode(71625222),1,1)
	
	--Toss a coin and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN+CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.toss_coin=true
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local hg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,hg,#hg,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CallCoin(tp) then
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup()
		local sum=dg:Filter(Card.IsPreviousPosition,nil,POS_FACEUP):GetSum(Card.GetBaseAttack)
		Duel.Damage(1-tp,sum/2,REASON_EFFECT)
	else
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		local ct=Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.Damage(tp,ct*500,REASON_EFFECT)
	end
end