--電磁石の戦士マグネット・ベルセリオン
--Berserkion the Electromagna Warrior
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND+LOCATION_DECK)
	e4:SetCondition(s.spcon4)
	e4:SetTarget(s.sptg4)
	e4:SetOperation(s.spop4)
	c:RegisterEffect(e4)

	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)

	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(s.spcon2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
	local e32=e3:Clone()
	e32:SetType(EFFECT_TYPE_IGNITION)
	e32:SetRange(LOCATION_MZONE)
	e32:SetCondition(s.spcon22)
	c:RegisterEffect(e32)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,4))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.tgcon)
	e5:SetTarget(s.numtg)
	e5:SetOperation(s.numop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetCondition(s.condition)
	c:RegisterEffect(e6)
	local chain=Duel.GetCurrentChain
	copychain=0
	Duel.GetCurrentChain=function()
		if copychain==1 then copychain=0 return chain()-1
		else return chain() end
	end
end
s.listed_series={0x2066}
s.listed_names={42023223,79418928,15502037,CARD_SHINING_SARCOPHAGUS,99785935,39256679,11549357}

function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(s.cchk1,1,nil,sg)
end
function s.cchk1(c,sg)
	return c:IsCode(42023223) and sg:IsExists(s.cchk2,1,nil,sg)
end
function s.cchk2(c,sg)
	return c:IsCode(79418928) and sg:FilterCount(s.cchk3,c)==1
end
function s.cchk3(c)
	return c:IsCode(15502037)
end
function s.cfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true,true)
end
function s.spcon(e,c)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()
	local rg1=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c,42023223)
	local rg2=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c,79418928)
	local rg3=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c,15502037)
	local rg=rg1:Clone()
	rg:Merge(rg2)
	rg:Merge(rg3)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and #rg1>0 and #rg2>0 and #rg3>0 
		and aux.SelectUnselectGroup(rg,e,tp,3,3,s.rescon,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c,42023223)
	rg:Merge(Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c,79418928))
	rg:Merge(Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,c,15502037))
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,s.rescon,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end

function s.rescon4(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(s.chk4,1,nil,sg,Group.CreateGroup(),99785935,39256679,11549357)
end
function s.chk4(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(s.chk4,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function s.spcon4(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp,true)
	local g1=rg:Filter(Card.IsCode,nil,99785935)
	local g2=rg:Filter(Card.IsCode,nil,39256679)
	local g3=rg:Filter(Card.IsCode,nil,11549357)
	local g=g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and #g1>0 and #g2>0 and #g3>0 
		and aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon4,0)
end
function s.sptg4(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp,true):Filter(Card.IsCode,nil,99785935,39256679,11549357)
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,s.rescon4,1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop4(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.costfilter(c)
	return c:IsMonster() and (c:IsSetCard(0x2066) or c:IsCode(99785935,39256679,11549357)) and c:IsLevelBelow(4) and c:IsAbleToRemoveAsCost() 
		and aux.SpElimFilter(c,true)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (rp~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp))
end
function s.spcon22(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_SHINING_SARCOPHAGUS),0,LOCATION_ONFIELD,0,1,nil)
end
function s.spfilter(c,e,tp,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,42023223)
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,79418928)
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,15502037)
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,42023223)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,79418928)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,15502037)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetTargetCards(e)
	if ft<=0 or #g==0 or #g>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if #g<=ft then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end

function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsLocation(LOCATION_MZONE) then return false end
	return Duel.CheckChainTarget(ev,tc) and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_SHINING_SARCOPHAGUS),0,LOCATION_ONFIELD,0,1,nil)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_SHINING_SARCOPHAGUS),0,LOCATION_ONFIELD,0,1,nil)
end
function s.tgfilter(c,e,tp,eg,ep,ev,re,r,rp,chain,chk)
	local te=c:GetActivateEffect()
	if not c:IsTrap() or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	if te:GetCode()==EVENT_CHAINING then
		if chain<=0 then return false end
		local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local tc=te2:GetHandler()
		local g=Group.FromCards(tc)
		local p=tc:GetControler()
		return (not condition or condition(e,tp,g,p,chain,te2,REASON_EFFECT,p)) and (not cost or cost(e,tp,g,p,chain,te2,REASON_EFFECT,p,0)) 
			and (not target or target(e,tp,g,p,chain,te2,REASON_EFFECT,p,0))
	elseif (te:GetCode()==EVENT_FREE_CHAIN and e:GetCode()==EVENT_FREE_CHAIN) 
		or (te:GetCode()==EVENT_SPSUMMON and e:GetCode()==EVENT_SPSUMMON) then
		if te:GetCode()==EVENT_SPSUMMON and chk then copychain=1 end
		return (not condition or condition(e,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0))
			and (not target or target(e,tp,eg,ep,ev,re,r,rp,0))
	else
		return false
	end
end
function s.numtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chain=Duel.GetCurrentChain()
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp,chain) end
end
function s.numop(e,tp,eg,ep,ev,re,r,rp)
	local chain=Duel.GetCurrentChain()-1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp,chain,true)
	local tc=g:GetFirst()
	copychain=0
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local te=tc:GetActivateEffect()
		local cost=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if te:GetCode()==EVENT_CHAINING then
			local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local tc=te2:GetHandler()
			local g=Group.FromCards(tc)
			local p=tc:GetControler()
			if co then co(e,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
			if tg then tg(e,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
			if op then op(e,tp,g,p,chain,te2,REASON_EFFECT,p) end
		else
			if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end