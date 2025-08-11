local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)	
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x316}
s.listed_names={511310104,511310105}

function s.dfilter(c)
	return c:IsSetCard(0x316) and c:IsType(TYPE_MONSTER)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x316) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(id)~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
end
function s.darkness(c)
	return c:IsFaceup() and c:GetFlagEffect(id)~=0 and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS) and c:IsSetCard(0x316)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)==0 then return end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local efg=Duel.SelectMatchingCard(tp,s.dfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #efg<1 then return end
	local ct=Duel.Destroy(efg,REASON_EFFECT)
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)
	if ft>0 then
		local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(6459419,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local fg=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(fg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	local g=Duel.GetMatchingGroup(s.darkness,tp,LOCATION_SZONE,0,e:GetHandler())
	if g:GetCount()>0 then
		while g:GetCount()>0 do
			local tc=g:GetFirst()
			s.zero(e:GetHandler(),tp)
			g:RemoveCard(tc)
		end
	end
end

function s.zero(tc,tep)
	local te=tc:GetActivateEffect()
	if te==nil or tc:CheckActivateEffect(true,false,false)==nil then return end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	Duel.ClearTargetCard()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
	tc:CreateEffectRelation(te)
	local gg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if gg then  
		local etc=gg:GetFirst()	
		while etc do
			etc:CreateEffectRelation(te)
			etc=gg:GetNext()
		end
	end						
	if operation then 
		Duel.Hint(HINT_SELECTMSG,tep,HINTMSG_DESTROY)
		local efg=Duel.SelectMatchingCard(tep,s.dfilter,tep,LOCATION_DECK,0,1,1,nil)
		if #efg<1 then return end
		local ct=Duel.Destroy(efg,REASON_EFFECT)
		local ft=Duel.GetLocationCountFromEx(tep,tep,nil,TYPE_FUSION)
		if ft>0 then
			local sg=Duel.GetMatchingGroup(s.spfilter,tep,LOCATION_EXTRA,0,nil,te,tep)
			if sg:GetCount()>0 and Duel.SelectYesNo(tep,aux.Stringid(6459419,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tep,HINTMSG_SPSUMMON)
				local fg=sg:Select(tep,1,1,nil)
				Duel.SpecialSummon(fg,0,tep,tep,false,false,POS_FACEUP_DEFENSE)
			end
		end
	end
	tc:ReleaseEffectRelation(te)					
	if gg then  
		local etc=gg:GetFirst()												 
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=gg:GetNext()
		end
	end 
end