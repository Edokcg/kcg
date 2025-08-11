--魔导月皇 娜芭特
function c77239696.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),9,2)
	c:EnableReviveLimit()
	
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c77239696.spcost)
	e1:SetOperation(c77239696.operation)
	c:RegisterEffect(e1)		
end
function c77239696.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239696.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=Duel.SelectOption(tp,aux.Stringid(77239696,0),aux.Stringid(77239696,1))
	if op==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetCountLimit(1)
		--e1:SetCondition(c77239696.setcon)
		e1:SetTarget(c77239696.target)
		e1:SetOperation(c77239696.activate)
		c:RegisterEffect(e1)
	else
		--Pos Change
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_POSITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(POS_FACEUP_DEFENSE)
		c:RegisterEffect(e1) 
		--Effect Draw
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DRAW_COUNT)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(1,0)
		e2:SetValue(2)
		c:RegisterEffect(e2)
	end
end
function c77239696.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function c77239696.filter(c)
	return c:IsAbleToGrave()--c:IsType(TYPE_MONSTER)
end
function c77239696.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239696.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,3,nil) end
	local g=Duel.GetMatchingGroup(c77239696.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,3,0,0)
end
--[[function c77239696.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239696.filter,tp,0,LOCATION_MZONE+LOCATION_HAND,nil)
	if g:GetCount()>4 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end]]

function c77239696.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239696.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,3,3,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end