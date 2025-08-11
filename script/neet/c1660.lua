--圣蔓之大贤者（neet）
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),2)
--must link summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.lnklimit)
	c:RegisterEffect(e1)
  --destroy
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_DESTROY)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EVENT_LEAVE_FIELD)
	e10:SetCondition(s.descon)
	e10:SetTarget(s.destg)
	e10:SetOperation(s.desop)
	c:RegisterEffect(e10)
--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
--Negate activation
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.discon)
	e3:SetCost(s.discost)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	aux.DoubleSnareValidity(c,LOCATION_MZONE)
end
s.listed_series={0x1157}
function s.c1filter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0x1157) and c:IsType(TYPE_LINK) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.c1filter,1,nil,tp,rp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function s.filter(c,tp)
	return c:IsFaceup() and  c:IsType(TYPE_LINK) and c:IsSetCard(0x1157) and Duel.IsPlayerCanDraw(tp,c:GetLink())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	local ct=g:GetFirst():GetLink()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,ct)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=tc:GetLink()
	if tc and tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		if  Duel.Draw(p,tc:GetLink(),REASON_EFFECT) then
			local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
			if #g==0 then return end
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=g:Select(p,ct,ct,nil)
			Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
			if ct>0 then
				Duel.SortDeckbottom(p,p,ct)
			end
		end
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
