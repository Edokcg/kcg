--奥利哈刚第四层结界控神阵(ZCG)
function c77239264.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c77239264.con)
	e0:SetTarget(c77239264.target1) 
	e0:SetOperation(c77239264.activate1)	
	c:RegisterEffect(e0)
	
	--检索
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetDescription(aux.Stringid(77239264,0)) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCost(c77239264.cost)
	e1:SetTarget(c77239264.tg)
	e1:SetOperation(c77239264.op)
	c:RegisterEffect(e1)

	--特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetDescription(aux.Stringid(77239264,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c77239264.target2)
	e2:SetOperation(c77239264.operation2)
	--c:RegisterEffect(e2)

	--特殊召唤
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetDescription(aux.Stringid(77239264,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c77239264.cost1)	 
	e3:SetTarget(c77239264.target3)
	e3:SetOperation(c77239264.operation3)
	c:RegisterEffect(e3)	
	
	--不会被破坏
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)	
end
---------------------------------------------------------------------------------
function c77239264.filter0(c)
	return c:GetOriginalCodeRule()==48179391
end
function c77239264.filter1(c)
	return c:GetOriginalCodeRule()==110000100
end
function c77239264.filter2(c)
	return c:GetOriginalCodeRule()==110000101
end
function c77239264.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end 
end
function c77239264.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239264.filter0,tp,LOCATION_GRAVE,0,nil)
	local g1=Duel.GetMatchingGroup(c77239264.filter1,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c77239264.filter2,tp,LOCATION_GRAVE,0,nil)   
	g:Merge(g1) 
	g:Merge(g2)	 
	Duel.Overlay(e:GetHandler(),g)  
	e:GetHandler():CopyEffect(77239261,1)		 
	e:GetHandler():CopyEffect(77239262,1)
	e:GetHandler():CopyEffect(77239263,1)	 
end
function c77239264.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(110000101,tp)
end
---------------------------------------------------------------------------------
function c77239264.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end

function c77239264.filter11(c)
	return c:IsCode(48179391) and c:IsAbleToHand()
end
function c77239264.filter12(c)
	return c:IsCode(110000100) and c:IsAbleToHand()
end
function c77239264.filter13(c)
	return c:IsCode(110000101) and c:IsAbleToHand()
end
function c77239264.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239264.filter11,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil)
	or Duel.IsExistingMatchingCard(c77239264.filter12,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil)
	or Duel.IsExistingMatchingCard(c77239264.filter13,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function c77239264.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c77239264.filter11,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c77239264.filter12,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil)
	local g3=Duel.SelectMatchingCard(tp,c77239264.filter13,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)	
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)		
	end
end
---------------------------------------------------------------------------------
function c77239264.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>0 end
	local lp=Duel.GetLP(tp)
	Duel.PayLPCost(tp,lp-1)
end
function c77239264.filter111(c,e,tp)
	return c:IsSetCard(0xa50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239264.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239264.filter111,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77239264.operation3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77239264.filter111,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
---------------------------------------------------------------------------------
function c77239264.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c77239264.filter5(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:GetLevel()==5 or c:GetLevel()==6) and c:IsSetCard(0xa50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239264.filter7(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:GetLevel()==7 or c:GetLevel()==8) and c:IsSetCard(0xa50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239264.filter9(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(9) and c:IsSetCard(0xa50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239264.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239264.filter11,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239264.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local b1=Duel.IsExistingMatchingCard(c77239264.filter11,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c77239264.filter11,tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,1,nil,e,tp) 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not (b1 or b2) then return end
		local ops={}
		local opval={}
		local off=1
		if b1 then
		ops[off]=aux.Stringid(77239264,2)
		opval[off-1]=1
		off=off+1
		end
		if b2 then
		ops[off]=aux.Stringid(77239264,3)
		opval[off-1]=2
		off=off+1
		end
	local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			local opt=0
			local x=Duel.IsExistingMatchingCard(c77239264.filter5,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
			local x1=Duel.IsExistingMatchingCard(c77239264.filter7,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
			local x2=Duel.IsExistingMatchingCard(c77239264.filter9,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
			if x and x1 and x2 then
				opt=Duel.SelectOption(tp,aux.Stringid(77239264,4),aux.Stringid(77239264,5),aux.Stringid(77239264,6))
			elseif x and x1 then
				opt=Duel.SelectOption(tp,aux.Stringid(77239264,4),aux.Stringid(77239264,5))
			elseif x1 and x2 then
				opt=Duel.SelectOption(tp,aux.Stringid(77239264,5),aux.Stringid(77239264,6))	 
			elseif x and x2 then
				opt=Duel.SelectOption(tp,aux.Stringid(77239264,4),aux.Stringid(77239264,6))		 
			elseif x then
				opt=Duel.SelectOption(tp,aux.Stringid(77239264,4))
			elseif x1 then
				opt=Duel.SelectOption(tp,aux.Stringid(77239264,5))			  
			elseif x2 then
				opt=Duel.SelectOption(tp,aux.Stringid(77239264,6))			  
			else return end
			
			
			
			--local g=Duel.SelectMatchingCard(tp,c77239264.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,1,3,nil,e,tp)
			--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) 
			--Duel.SendtoGrave(g,REASON_EFFECT)		 
			--if g:GetCount()==1 then
			--	local g1=Duel.SelectMatchingCard(tp,c77239264.filter5,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
			--	if g1:GetCount()>0 then
			--		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			--	end
			--elseif
			--	g:GetCount()==2 then
			--   local g2=Duel.SelectMatchingCard(tp,c77239264.filter7,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
			--	if g2:GetCount()>0 then
			--		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			--	end		   
			--elseif
			--	local g3=Duel.SelectMatchingCard(tp,c77239264.filter9,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
			--	if g3:GetCount()>0 then
			--		Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
			--	end							  
			--else return end   
		else

	end
end
