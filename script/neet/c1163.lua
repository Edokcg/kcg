--库萨伊之虫惑魔(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.immfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
s.listed_series={0x4c,0x89}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 and Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)>0 end
end
function s.filter(c)
	return c:GetType()==TYPE_TRAP and (c:IsSetCard(0x4c) or c:IsSetCard(0x89)) and c:IsSSetable()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local sg=g:Filter(s.filter,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)
	if #g>0 then
		--Duel.DisableShuffleCheck()
		if #sg>0 and ft>0 then
			local tg=aux.SelectUnselectGroup(sg,e,tp,math.min(ft,#sg),math.min(ft,#sg),nil,1,tp,HINTMSG_SET)
			if #tg>0 then
				Duel.SSet(tp,tg)
			end
		end
	end
end
function s.immfilter(e,te)
	local c=te:GetOwner()
	return c:GetType()==TYPE_TRAP and (c:IsSetCard(SET_HOLE) or c:IsSetCard(SET_TRAP_HOLE))
end
function s.cpfilter(c)
	return c:GetType()==TYPE_TRAP and (c:IsSetCard(SET_HOLE) or c:IsSetCard(SET_TRAP_HOLE)) and c:IsAbleToRemoveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil and c:CheckActivateEffect(false,true,false):GetOperation()~=nil
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chain=Duel.GetCurrentChain()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,chk,chain) end
	chain=chain-1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,chk,chain)
	local te,teg,tep,tev,tre,tr,trp=g:GetFirst():CheckActivateEffect(false,true,true)
	if not te then te=g:GetFirst():GetActivateEffect() end
	if te:GetCode()==EVENT_CHAINING then
		if chain<=0 then return false end
		local te2,p=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te2:GetHandler()
		local g=Group.FromCards(tc)
		teg,tep,tev,tre,tr,trp=g,p,chain,te2,REASON_EFFECT,p
	end
	s[Duel.GetCurrentChain()]=te
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetTarget(s.targetchk(teg,tep,tev,tre,tr,trp))
	e:SetOperation(s.operationchk(teg,tep,tev,tre,tr,trp))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_CHAIN)
	e1:SetLabelObject(e)
	e1:SetOperation(s.resetop)
	Duel.RegisterEffect(e1,tp)
end
function s.targetchk(teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local te=s[Duel.GetCurrentChain()]
				if chkc then
					local tg=te:GetTarget()
					return tg(e,tp,teg,tep,tev,tre,tr,trp,0,true)
				end
				if chk==0 then return true end
				if not te then return end
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				local tg=te:GetTarget()
				if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,1) end
			end
end
function s.operationchk(teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp)
				local te=s[Duel.GetCurrentChain()]
				if not te then return end
				local op=te:GetOperation()
				if op then op(e,tp,teg,tep,tev,tre,tr,trp) end
			end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		te:SetTarget(s.target2)
		te:SetOperation(s.operation)
	end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=s[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=s[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end