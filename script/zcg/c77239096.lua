--神石板 神哮(ZCG)
function c77239096.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c77239096.condition)
    e1:SetTarget(c77239096.target)
    e1:SetOperation(c77239096.activate)
    c:RegisterEffect(e1)
end
function c77239096.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c77239096.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end	
end
function c77239096.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	local ga=g1:GetMaxGroup(Card.GetAttack)
	local gd=g2:GetMaxGroup(Card.GetAttack)
	if ga:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239096,0))
		ga=ga:Select(tp,1,1,nil)
	end
	if gd:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239096,1))
		gd=gd:Select(tp,1,1,nil)
	end
	local a=ga:GetFirst()
	local d=gd:GetFirst()
	if a:GetAttack()<d:GetAttack() then 
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(d:GetAttack())
        a:RegisterEffect(e1)
    end
end
