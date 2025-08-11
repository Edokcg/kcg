--神炎皇 乌利亚
local s, id = GetID()
function s.initial_effect(c)
	aux.god(c,1,id,0)

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(805)
    e0:SetValue(1)
    c:RegisterEffect(e0)

	c:EnableReviveLimit()
	
	--特殊召唤方式
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	--攻守为墓地陷阱卡数量
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	--破坏对方场上1张覆盖的陷阱
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10000024,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	
	--丢弃手牌陷阱卡后墓地特殊召唤
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10000024,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1)
	e6:SetCost(s.fcost)
	e6:SetTarget(s.ftg)
	e6:SetOperation(s.fop)
	c:RegisterEffect(e6)

	local e114=Effect.CreateEffect(c)
	e114:SetType(EFFECT_TYPE_SINGLE)
	e114:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e114:SetCode(EFFECT_ADD_RACE)
	e114:SetValue(RACE_DRAGON)
	c:RegisterEffect(e114)
	local e115=e114:Clone()
	e115:SetCode(EFFECT_ADD_ATTRIBUTE)
	e115:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e115)
end
---------------------------------------------------------------------------------------------------------------
function s.spfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end

function s.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		return Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_ONFIELD,0,3,nil)
	else
		return Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_ONFIELD,0,3,nil)
	end
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_ONFIELD,0,2,2,g1:GetFirst())
		g2:AddCard(g1:GetFirst())
			local tc=g2:GetFirst()
			while tc do
			if tc:IsFacedown() then Duel.ConfirmCards(tp,tc) end
			tc=g2:GetNext() end
		Duel.SendtoGrave(g2,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
			local tc2=g:GetFirst()
			while tc2 do
			if tc2:IsFacedown() then Duel.ConfirmCards(tp,tc2) end
			tc2=g:GetNext() end
		Duel.SendtoGrave(g,REASON_COST)
	end
end
--------------------------------------------------------------------------------------------------------------
function s.atkfilter(c)
	return c:IsType(TYPE_TRAP) 
end

function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end
----------------------------------------------------------------------------------------------------------------
function s.desfilter(c)
	return c:IsFacedown() and c:GetSequence()~=5
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and s.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,s.desfilter,tp,0,LOCATION_SZONE,1,1,nil)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFaceup() then return end
	Duel.ConfirmCards(tp,tc)
	if tc:IsType(TYPE_TRAP) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			Duel.RaiseSingleEvent(c,10000024,e,0,tp,tp,0)
		end
	end
end
--------------------------------------------------------------------------------------------------
function s.costfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsDiscardable()
end

function s.fcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,s.costfilter,1,1,REASON_COST+REASON_DISCARD)
end

function s.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetCondition(s.atcon)
		c:RegisterEffect(e2)
	end
end

function s.atcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end