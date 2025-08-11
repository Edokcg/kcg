--流星黑龙(ZCG)
function c77239693.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)	
	-- xyzop
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c77239693.xyzcon)
	e2:SetOperation(c77239693.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)	

	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c77239693.val)
	c:RegisterEffect(e3)

	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239693,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1) 
	e4:SetCondition(c77239693.discon)
	e4:SetTarget(c77239693.distg)
	e4:SetOperation(c77239693.disop)
	c:RegisterEffect(e4)
	
	--disable attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(61303,1))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCountLimit(1)
	e5:SetCondition(c77239693.condition)
	e5:SetCost(c77239693.descost)
	e5:SetOperation(c77239693.activate)
	c:RegisterEffect(e5)		
end
------------------------------------------------------------------
function c77239693.hofilter(c,tp,xyzc)
	if c:IsType(TYPE_TOKEN) or not c:IsCanBeXyzMaterial(xyzc) then return false end
	return c:GetLevel()==8
end
function c77239693.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return Duel.IsExistingMatchingCard(c77239693.hofilter,tp,LOCATION_HAND+LOCATION_DECK,0,3,nil,tp,c)
end
function c77239693.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local mg=Duel.SelectMatchingCard(tp,c77239693.hofilter,tp,LOCATION_HAND+LOCATION_DECK,0,3,3,nil,tp,c)
	if mg:GetCount()<0 then return end
	c:SetMaterial(mg)
	Duel.Overlay(c, mg)
end
------------------------------------------------------------------
function c77239693.val(e,c)
	return c:GetOverlayCount()-1
end
------------------------------------------------------------------
function c77239693.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
		and Duel.IsChainNegatable(ev) and tp~=ep
end
function c77239693.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239693.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77239693.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
------------------------------------------------------------------
function c77239693.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77239693.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c77239693.activate(e,tp,eg,ep,ev,re,r,rp)
	--local tc=Duel.GetFirstTarget()
	--if tc:IsRelateToEffect(e) then
		Duel.NegateAttack()
	--end
end



