--超重武者装留 鬼臂（neet）
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Synchro summon procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),1,1,Synchro.NonTuner(nil),1,99)  
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_DEFENSE_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(s.effcon)
	e5:SetCost(s.cost)
	e5:SetTarget(s.efftg)
	e5:SetOperation(s.effop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_SUMMON)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.effcon)
	e6:SetCost(s.cost)
	e6:SetTarget(s.efftg)
	e6:SetOperation(s.effop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e8)
	local chain=Duel.GetCurrentChain
	copychain=0
	Duel.GetCurrentChain=function()
		if copychain==1 then copychain=0 return chain()-1
		else return chain() end
	end
end
s.listed_series={0x9a}
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9a)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(2300)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(function(e,ec) return ec==e:GetLabelObject() end)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetLabelObject(tc)
	c:RegisterEffect(e2)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and not Duel.IsExistingMatchingCard(Card.IsSpellTrap,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.cfilter(c,e,tp,eg,ep,ev,re,r,rp,chain,chk)
	local te=c:GetActivateEffect()
	if not te or not c:IsSpellTrap() then return false end
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
	elseif (te:GetCode()==EVENT_SPSUMMON or te:GetCode()==EVENT_SUMMON or te:GetCode()==EVENT_FLIP_SUMMON or te:GetCode()==EVENT_FREE_CHAIN) 
		and te:GetCode()==e:GetCode() then
		if chk then copychain=1 end
		return (not condition or condition(e,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) 
			and (not target or target(e,tp,eg,ep,ev,re,r,rp,0))
	else
		local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		return res and (not condition or condition(e,tp,teg,tep,tev,tre,tr,trp)) and (not cost or cost(e,tp,teg,tep,tev,tre,tr,trp,0))
			and (not target or target(e,tp,teg,tep,tev,tre,tr,trp,0))
	end
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local chain=Duel.GetCurrentChain()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and s.cfilter(e,tp,eg,ep,ev,re,r,rp,chain) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,eg,ep,ev,re,r,rp,chain) end
	chain=chain-1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,eg,ep,ev,re,r,rp,chain,true)
	copychain=0
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc then
		local te=tc:GetActivateEffect()
		if not te then return end
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		local res,teg,tep,tev,tre,tr,trp
		if te:GetCode()==EVENT_CHAINING then
			local chain=Duel.GetCurrentChain()-1
			local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local tc=te2:GetHandler()
			local g=Group.FromCards(tc)
			local p=tc:GetControler()
			teg,tep,tev,tre,tr,trp=g,p,chain,te2,REASON_EFFECT,p
		elseif te:GetCode()==EVENT_SUMMON or te:GetCode()==EVENT_FLIP_SUMMON or te:GetCode()==EVENT_SPSUMMON or te:GetCode()==EVENT_FREE_CHAIN then
			teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
		else
			res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		end
		e:GetHandler():CreateEffectRelation(te)
		if co then co(e,tp,teg,tep,tev,tre,tr,trp,1) end
		if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,1) end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc=g:GetNext()
		end
		if op then op(e,tp,teg,tep,tev,tre,tr,trp) end
		e:GetHandler():ReleaseEffectRelation(te)
		etc=g:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=g:GetNext()
		end
	end
end