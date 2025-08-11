--沉默的黑暗大法师lvmax
function c77239949.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,12,2)
	c:EnableReviveLimit()
	
	--special xyz_summon 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239949,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c77239949.spcon)
	e1:SetOperation(c77239949.spop)
	c:RegisterEffect(e1)

	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c77239949.tgvalue)
	c:RegisterEffect(e2)	
	
	--cannot disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(0)
	c:RegisterEffect(e3)	
	
	--disable
	local e31=Effect.CreateEffect(c)
	e31:SetType(EFFECT_TYPE_FIELD)
	e31:SetCode(EFFECT_DISABLE)
	e31:SetRange(LOCATION_MZONE)
	e31:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e31:SetTarget(c77239949.distg)
	c:RegisterEffect(e31)   
	--disable effect
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e32:SetCode(EVENT_CHAIN_SOLVING)
	e32:SetRange(LOCATION_MZONE)
	e32:SetOperation(c77239949.disop2)
	c:RegisterEffect(e32)   
	
	--adjust
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c77239949.condition)	
	e4:SetOperation(c77239949.adjustop)
	c:RegisterEffect(e4)	
	
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e5:SetValue(c77239949.ebcon)	
	c:RegisterEffect(e5)	

	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77239949,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCost(c77239949.cost)
	e6:SetTarget(c77239949.tg)
	e6:SetOperation(c77239949.op)
	c:RegisterEffect(e6)

	--
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77239949,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e7:SetCost(c77239949.cost)
	e7:SetTarget(c77239949.tg1)
	e7:SetOperation(c77239949.op1)
	c:RegisterEffect(e7)
	
	--
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77239949,2))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e8:SetCost(c77239949.cost)
	e8:SetTarget(c77239949.tg2)
	e8:SetOperation(c77239949.op2)
	c:RegisterEffect(e8)
end
-------------------------------------------------------------------------
function c77239949.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckLPCost(tp,500)
	and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_EXTRA,0,2,nil,0x48)
end
function c77239949.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,500)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_EXTRA,0,2,2,nil,0x48) 
	if g:GetCount()>0 then
		local tc=g:GetFirst()   
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
		g:RemoveCard(tc)
		Duel.Overlay(tc,g)
		Duel.Overlay(c,g)	   
		Duel.Overlay(c,tc)  
	end		
end
 -------------------------------------------------------------------------   
function c77239949.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
--------------------------------------------------------------------------
function c77239949.disop2(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xa60) and re:GetHandler():IsLocation(LOCATION_ONFIELD) then
		Duel.NegateEffect(ev)	  
	end
end
function c77239949.distg(e,c)
	return c:IsSetCard(0xa60)
end
--------------------------------------------------------------------------
function c77239949.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa60)
end
function c77239949.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77239949.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and
	Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c77239949.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77239949.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.Damage(1-tp,ct*2000,REASON_EFFECT)
end
--------------------------------------------------------------------------
function c77239949.ebcon(e,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
--------------------------------------------------------------------------
function c77239949.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239949.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>2 end
end
function c77239949.op(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_EXODIA = 0x10
	Duel.Win(tp,WIN_REASON_EXODIA)
end
--------------------------------------------------------------------------
function c77239949.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239949.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
--------------------------------------------------------------------------
function c77239949.filter(c)
	return c:IsAbleToHand()
end
function c77239949.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239949.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239949.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77239949.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



