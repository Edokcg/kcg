--阴阳战士
function c77239049.initial_effect(c)
	--提升攻击力
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77239049.val)
	c:RegisterEffect(e1)
	
    --破坏战士族
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c77239049.discon)	
    e2:SetTarget(c77239049.target)
    e2:SetOperation(c77239049.activate)
    c:RegisterEffect(e2)	
end
function c77239049.val(e,c)
	return Duel.GetMatchingGroupCount(c77239049.filter1,c:GetControler(),LOCATION_MZONE,0,nil)*500
end
function c77239049.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
--------------------------------------------------------------------------
function c77239049.discon(e,tp,eg,ep,ev,re,r,rp)
	return  1-tp==Duel.GetTurnPlayer()
end
function c77239049.filter(c)
    return c:IsRace(RACE_WARRIOR) and c:IsFaceup()
end
function c77239049.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239049.filter,tp,0,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(c77239049.filter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239049.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239049.filter,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end