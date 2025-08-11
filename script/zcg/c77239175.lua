--雪人团的堡垒(ZCG)
function c77239175.initial_effect(c)
	--xyz summon
	if aux.IsKCGScript then
		Xyz.AddProcedure(c,nil,4,2)
	else
		aux.AddXyzProcedure(c,nil,4,2)
	end
	c:EnableReviveLimit()
	
	--放置
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c77239175.secon)
	e1:SetTarget(c77239175.setg)
	e1:SetOperation(c77239175.seop)
	c:RegisterEffect(e1)

	--攻击
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239175,0)) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)   
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c77239175.cost)
	e2:SetCondition(c77239175.condition)
	e2:SetTarget(c77239175.target)
	e2:SetOperation(c77239175.activate)
	c:RegisterEffect(e2)

	--不会成为攻击对象
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c77239175.atkcon)   
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)

	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(aux.bdogcon)
	e5:SetTarget(c77239175.damtg)
	e5:SetOperation(c77239175.damop)
	c:RegisterEffect(e5)	
end
	function c77239175.secon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c77239175.filter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end
function c77239175.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239175.filter,tp,LOCATION_DECK,0,2,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 end
end
function c77239175.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c77239175.filter,tp,LOCATION_DECK,0,2,2,nil)
	if #g<=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 then return end
	Duel.SSet(tp,g) 
end

function c77239175.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239175.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77239175.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c77239175.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:CanAttack() and Duel.NegateAttack() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
----------------------------------------------------------------------------
function c77239175.atkcon(e,c)
	return  e:GetHandler():GetOverlayCount()==0
end
----------------------------------------------------------------------------
function c77239175.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c77239175.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
