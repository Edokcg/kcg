--梵天使徒 混沌终结者
function c77239886.initial_effect(c)
	c:EnableCounterPermit(0xa11)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,3)
	c:EnableReviveLimit()

	--Add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c77239886.op)
	c:RegisterEffect(e1)

	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetDescription(aux.Stringid(77239886,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c77239886.cost1)
	e2:SetOperation(c77239886.operation1)
	c:RegisterEffect(e2)

	--Attack
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetDescription(aux.Stringid(77239886,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c77239886.cost2)
	e3:SetOperation(c77239886.operation2)
	c:RegisterEffect(e3)

	--Damage
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetDescription(aux.Stringid(77239886,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCost(c77239886.cost3)
	e4:SetOperation(c77239886.operation3)
	c:RegisterEffect(e4)
end

function c77239886.op(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_QUICKPLAY) and c~=e:GetHandler() then
		e:GetHandler():AddCounter(0xa11,1)
	end
end

function c77239886.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	and Duel.IsCanRemoveCounter(tp,1,0,0xa11,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0xa11,1,REASON_COST)
end
function c77239886.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
end
function c77239886.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239886.filter,tp,LOCATION_DECK,0,nil)
		if #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g:Select(tp,1,1,nil)
			Duel.SSet(tp,tc)
		end
end

function c77239886.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsCanRemoveCounter(tp,1,0,0xa11,2,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		Duel.RemoveCounter(tp,1,0,0xa11,2,REASON_COST)
end
function c77239886.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

function c77239886.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsCanRemoveCounter(tp,1,0,0xa11,3,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		Duel.RemoveCounter(tp,1,0,0xa11,3,REASON_COST)
end
function c77239886.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,2500,REASON_EFFECT)
	Duel.Recover(tp,2500,REASON_EFFECT)
end