--スフィア・フィールド
function c146.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	  --e1:SetOperation(c146.actop)
	c:RegisterEffect(e1)

	--XYZ
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13710,0))
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c146.target)
	e2:SetOperation(c146.operation)
	c:RegisterEffect(e2)

	--activation
	local e80=Effect.CreateEffect(c)
	e80:SetType(EFFECT_TYPE_FIELD)
	e80:SetCode(EFFECT_CANNOT_TRIGGER)
	e80:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e80:SetRange(LOCATION_FZONE)
	e80:SetTargetRange(0xa,0xa)
	e80:SetTarget(c146.aclimit2)
	--c:RegisterEffect(e80)

	--场上存在时不能放置场地魔法卡
	local e82=Effect.CreateEffect(c)
	e82:SetType(EFFECT_TYPE_FIELD)
	e82:SetCode(EFFECT_CANNOT_SSET)
	e82:SetRange(LOCATION_FZONE)
	e82:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e82:SetTargetRange(1,1)
	e82:SetTarget(c146.sfilter)
	--c:RegisterEffect(e82)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e7)
	local e104=e4:Clone()
	e104:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e104)
	local e105=e4:Clone()
	e105:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e105)
	local e106=e4:Clone()
	e106:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e106)
	local e107=e4:Clone()
	e107:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e107)
	local e108=e4:Clone()
	e108:SetCode(EFFECT_IMMUNE_EFFECT)
	e108:SetValue(c146.efilterr)		
	c:RegisterEffect(e108)  
	local e109=e4:Clone()
	e109:SetCode(EFFECT_CANNOT_USE_AS_COST)
	c:RegisterEffect(e109)
	local e111=e4:Clone()
	e111:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e111)  
end

function c146.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local oppfield=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if (oppfield~=nil and not (oppfield:IsCode(10) or oppfield:IsCode(11) or oppfield:IsCode(12) or oppfield:IsCode(12201) or oppfield:IsCode(190))) 
	or (oppfield~=nil and (oppfield:IsCode(10) or oppfield:IsCode(11) or oppfield:IsCode(12) or oppfield:IsCode(12201) or oppfield:IsCode(190)) and oppfield:IsFacedown()) then
	Duel.Destroy(oppfield,REASON_RULE) end
end

function c146.fromhandfilter(c)
	return (c:IsCode(10) or c:IsCode(11) or c:IsCode(12) or c:IsCode(12201) or c:IsCode(190)) and c:IsFaceup()
end
function c146.fromhandcon(e,tp,eg,ep,ev,re,r,rp)
	  return not Duel.IsExistingMatchingCard(c146.fromhandfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
	  --Duel.GetFlagEffect(e:GetHandler():GetControler(),5)==0 
end
function c146.fromhandop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc then
		--Duel.RegisterFlagEffect(e:GetHandler():GetControler(),5,0,0,0)
		local oppfield=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		local myfield=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x23)
		if oppfield~=nil and oppfield:IsFaceup() and (oppfield:IsCode(10) or oppfield:IsCode(11) or oppfield:IsCode(12) or oppfield:IsCode(12201) or oppfield:IsCode(190)) then return end
		if myfield~=nil and myfield:IsFaceup() and (myfield:IsCode(10) or myfield:IsCode(11) or myfield:IsCode(12) or myfield:IsCode(12201) or myfield:IsCode(190)) then return end
		if oppfield~=nil then
		Duel.Destroy(oppfield,REASON_RULE)
		if g:GetCount()~=0 then Duel.Destroy(g,REASON_RULE) end
		Duel.BreakEffect() end
		if myfield~=nil then
		Duel.Destroy(myfield,REASON_RULE)
		if g:GetCount()~=0 then Duel.Destroy(g,REASON_RULE) end
		Duel.BreakEffect() end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		--if tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup() then
		--local te=tc:GetActivateEffect()
		--local tep=tc:GetControler()
	  --local condition=te:GetCondition()
	  --local cost=te:GetCost()
	  --local target=te:GetTarget()
	  --local operation=te:GetOperation()
	  --e:SetProperty(te:GetProperty())
	  --tc:CreateEffectRelation(te) 
	  --if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	  --if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
	  --if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
	  --tc:ReleaseEffectRelation(te)  
		--Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain()) end
	end
end

function c146.filter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function c146.lvfilter(c,lv)
	return c:GetLevel()==lv and lv>0
end
function c146.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g1=Duel.GetMatchingGroup(c146.filter,tp,LOCATION_HAND,0,nil,e)
		local g2=Duel.GetMatchingGroup(c146.filter,tp,LOCATION_HAND,0,nil,e)
		local gg=g1:GetFirst()
		local lv=0
		local mg1=Group.CreateGroup()
		local mg2=nil
		while gg do
			lv=gg:GetLevel()
			mg2=g2:Filter(c146.lvfilter,gg,lv)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
				mg1:AddCard(gg)
			end  
			gg=g1:GetNext()
		end
		if mg1:GetCount()>1 and Duel.IsExistingMatchingCard(c146.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)>0 
		then
		return true
		else
		return false
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c146.xyzfilter(c,e,tp)
	return c:IsSetCard(0x48) and not c:IsSetCard(0x1048) and not c:IsSetCard(0x2048) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c146.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(c146.filter,tp,LOCATION_HAND,0,nil,e)
	local g2=Duel.GetMatchingGroup(c146.filter,tp,LOCATION_HAND,0,nil,e)
	local gg=g1:GetFirst()
	local lv=0
	local mg1=Group.CreateGroup()
	local mg2=nil
	while gg do
		lv=gg:GetLevel()
		mg2=g2:Filter(c146.lvfilter,gg,lv)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			mg1:AddCard(gg)
		end  
		gg=g1:GetNext()
	end
	if mg1:GetCount()>1 and Duel.IsExistingMatchingCard(c146.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		local tg1=mg1:Select(tp,1,1,nil):GetFirst()   
		local tg2=mg1:FilterSelect(tp,c146.lvfilter,1,1,tg1,tg1:GetLevel())
		tg2:AddCard(tg1)			
		if tg2:GetCount()<2 then return end
		local xyzg=Duel.GetMatchingGroup(c146.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:RandomSelect(tp,1):GetFirst()	
			if Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP) then
				--destroy
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)				
				e1:SetRange(LOCATION_MZONE)
				e1:SetCode(EFFECT_SELF_DESTROY)
				e1:SetCondition(c146.descon)
				e1:SetReset(RESET_EVENT+0xff0000)
				xyz:RegisterEffect(e1,true)
				xyz:SetMaterial(tg2)
				Duel.Overlay(xyz,tg2)
				Duel.SpecialSummonComplete()	
						xyz:CompleteProcedure()
			end	
		end  
	end 
end
function c146.descon(e)
	return e:GetHandler():GetOverlayCount()==0 and e:GetHandler():IsDestructable() and Duel.GetCurrentChain()==0
end
function c146.aclimit(e,re)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_FIELD)
end
function c146.aclimit2(e,c)
	return c:IsType(TYPE_FIELD) and not c:IsCode(190) and not c:IsCode(10) and not c:IsCode(11) and not c:IsCode(12) and not c:IsCode(12201) and not c:IsCode(100000186)
end
function c146.sfilter(e,c,tp)
	return c:IsType(TYPE_FIELD) and Duel.GetFieldCard(tp,LOCATION_SZONE,5)~=nil and not (c:IsCode(190) and not c:IsCode(10) and not c:IsCode(11) and not c:IsCode(12) and not c:IsCode(12201))
end
function c146.tgn(e,c)
	return c==e:GetHandler()
end

function c146.efilterr(e,te)
	return te:GetOwner()~=e:GetOwner()
end