--奥利哈刚第五层结界操控阵(ZCG)
function c77239265.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetDescription(aux.Stringid(77239265,3))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c77239265.con)
	e0:SetTarget(c77239265.target1) 
	e0:SetOperation(c77239265.activate1)	
	c:RegisterEffect(e0)

	--检索
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetDescription(aux.Stringid(77239265,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCost(c77239265.cost)
	e1:SetTarget(c77239265.tg)
	e1:SetOperation(c77239265.op)
	c:RegisterEffect(e1)

	--除外
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetDescription(aux.Stringid(77239265,0)) 
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1) 
	e2:SetTarget(c77239265.target)
	e2:SetOperation(c77239265.activate)
	c:RegisterEffect(e2)
	
	--攻击力提升
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c77239265.value)
	c:RegisterEffect(e3)

	--不能发动场地魔法卡
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c77239265.aclimit)
	c:RegisterEffect(e4)
	
	--效果免疫
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c77239265.efilter)
	c:RegisterEffect(e5)
	
	--直接攻击
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77239265,1))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCost(c77239265.cost1) 
	e6:SetTarget(c77239265.datg)
	e6:SetOperation(c77239265.daop)
	c:RegisterEffect(e6)	
	
	--不会被破坏
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(1)
	c:RegisterEffect(e7)
  
end
---------------------------------------------------------------------------------
function c77239265.filter(c)
	return c:GetOriginalCodeRule()==48179391
end
function c77239265.filter1(c)
	return c:GetOriginalCodeRule()==110000100
end
function c77239265.filter2(c)
	return c:GetOriginalCodeRule()==110000101
end
function c77239265.filter3(c)
	return c:GetOriginalCodeRule()==77239264
end
function c77239265.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end 
end
function c77239265.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239265.filter,tp,LOCATION_GRAVE,0,nil)
	local g1=Duel.GetMatchingGroup(c77239265.filter1,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c77239265.filter2,tp,LOCATION_GRAVE,0,nil)
	local g3=Duel.GetMatchingGroup(c77239265.filter3,tp,LOCATION_GRAVE,0,nil)   
	g:Merge(g1) 
	g:Merge(g2) 
	g:Merge(g3)	 
	Duel.Overlay(e:GetHandler(),g)  
	e:GetHandler():CopyEffect(77239261,1)		 
	e:GetHandler():CopyEffect(77239262,1)
	e:GetHandler():CopyEffect(77239263,1) 
	e:GetHandler():CopyEffect(77239264,1)	 
end
function c77239265.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(77239264,tp)
end
---------------------------------------------------------------------------------
function c77239265.filter5(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c77239265.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77239265.filter5,tp,0,LOCATION_HAND+LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c77239265.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239265.filter5,tp,0,LOCATION_HAND+LOCATION_ONFIELD,e:GetHandler())
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*500,REASON_EFFECT)	   
	end
end
---------------------------------------------------------------------------------
function c77239265.value(e,c)
		return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_MONSTER)*500
end
---------------------------------------------------------------------------------
function c77239265.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD)
end
---------------------------------------------------------------------------------
function c77239265.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
---------------------------------------------------------------------------------
function c77239265.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>0 end
	local lp=Duel.GetLP(tp)
	Duel.PayLPCost(tp,lp-1)
end
function c77239265.filter7(c)
	return c:IsFaceup()
end
function c77239265.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239265.filter7(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77239265.filter7,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c77239265.filter7,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77239265.daop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
---------------------------------------------------------------------------------
function c77239265.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c77239265.filter11(c)
	return c:IsCode(48179391) and c:IsAbleToHand()
end
function c77239265.filter12(c)
	return c:IsCode(110000100) and c:IsAbleToHand()
end
function c77239265.filter13(c)
	return c:IsCode(110000101) and c:IsAbleToHand()
end
function c77239265.filter14(c)
	return c:IsCode(77239264) and c:IsAbleToHand()
end
function c77239265.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239265.filter11,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil)
	or Duel.IsExistingMatchingCard(c77239265.filter12,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil)
	or Duel.IsExistingMatchingCard(c77239265.filter13,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil)
	or Duel.IsExistingMatchingCard(c77239265.filter14,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function c77239265.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c77239265.filter11,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c77239265.filter12,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil)
	local g3=Duel.SelectMatchingCard(tp,c77239265.filter13,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil)
	local g4=Duel.SelectMatchingCard(tp,c77239265.filter14,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil)  
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)	
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)		
	end
end
---------------------------------------------------------------------------------

