--
function c77239440.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --通常抽2
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DRAW_COUNT)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(1,0)
    e2:SetValue(2)
	e2:SetCondition(c77239440.con)	
    c:RegisterEffect(e2)
	
    --代价
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c77239440.mtcon)
	e3:SetOperation(c77239440.mtop)
	c:RegisterEffect(e3)	
end
---------------------------------------------------------------------
function c77239440.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa70)
end
function c77239440.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77239440.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
---------------------------------------------------------------------
function c77239440.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239440.mtop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(77239440,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
        Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
    else
        Duel.Destroy(e:GetHandler(),REASON_COST)
    end
end