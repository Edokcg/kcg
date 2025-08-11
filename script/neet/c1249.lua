--智天之神星骑(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 2+ monsters, including an "Zefra" monster
	Link.AddProcedure(c,nil,3,99,s.lcheck)
	--Place 2 "Zefra monsters from your Extra to your Pendulum Zones
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(s.pltg)
	e1:SetOperation(s.plop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.atkcon)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)	
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(s.negcon)
	e3:SetCost(s.cost)
	e3:SetTarget(s.negtg)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SUMMON)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(s.discon)
	e4:SetCost(s.cost)
	e4:SetTarget(s.distg)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4) 
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e5)
end
s.listed_series={0xc4}
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,2,nil,0xc4,lc,sumtype,tp)
end
function s.pcfilter(c)
	return c:IsSetCard(0xc4) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.pcfilter,tp,LOCATION_EXTRA,0,nil)
		return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.pcfilter,tp,LOCATION_EXTRA,0,nil)
	local pc=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pc=pc+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pc=pc+1 end
	if pc~=0 then
		local pg=aux.SelectUnselectGroup(g,e,tp,1,pc,aux.TRUE,1,tp,HINTMSG_TOFIELD)
		if #pg==0 then return end
		if #pg==2 then
			local pc1,pc2=pg:GetFirst(),pg:GetNext()
			if Duel.MoveToField(pc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
				if Duel.MoveToField(pc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
					pc2:SetStatus(STATUS_EFFECT_ENABLED,true)
				end
				pc1:SetStatus(STATUS_EFFECT_ENABLED,true)
			end
		else
			local pc1=pg:GetFirst()
			if Duel.MoveToField(pc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
				pc1:SetStatus(STATUS_EFFECT_ENABLED,true)
			end
		end
	end
end
function s.cfilter(c,ec)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_PENDULUM) and ec:GetLinkedGroup():IsContains(c) and c:IsSetCard(0xc4)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e:GetHandler())
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local g=eg:Filter(s.cfilter,nil,e:GetHandler())
	 local num=g:GetSum(Card.GetAttack)
	 local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	 if mg:GetCount()>0 then
		local tc=mg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-num)
			tc:RegisterEffect(e1)
			tc=mg:GetNext()
		end
	end
end
function s.rfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsSetCard(0xc4)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.rfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,s.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end