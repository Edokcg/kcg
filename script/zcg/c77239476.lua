--千年白虎
function c77239476.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --remain field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e2)
	
    --[[Activate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.String77239476(77239476,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c77239476.target)
    e3:SetOperation(c77239476.activate)
    c:RegisterEffect(e3)]]
	
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c77239476.target)
	e3:SetOperation(c77239476.activate)
	c:RegisterEffect(e3)

    --Effect Draw
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_DRAW_COUNT)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(1,0)
    e4:SetValue(2)
    c:RegisterEffect(e4)	
end
--------------------------------------------------------------------
--[[function c77239476.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c77239476.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.String77239476(77239476,1))
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,5,5,nil)
    local tc=g:GetFirst()
    if tc then
		Duel.ShuffleDeck(tp)
		Duel.ConfirmDecktop(tp,5)
        Duel.MoveSequence(tc,0)
    end
end]]

function c77239476.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c77239476.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,tp,5)
end