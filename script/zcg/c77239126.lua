--青眼水晶龙(ZCG)
function c77239126.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c77239126.spcon)
	e1:SetOperation(c77239126.spop)
	c:RegisterEffect(e1)

	--提升攻防
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1) 	
    e2:SetTarget(c77239126.adtg)
    e2:SetOperation(c77239126.adop)
	c:RegisterEffect(e2)

end
--------------------------------------------------------------------
function c77239126.spfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and not c:IsCode(77239126)
end
function c77239126.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239126.spfilter,tp,LOCATION_GRAVE,0,1,nil)   
end
function c77239126.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectMatchingCard(tp,c77239126.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
-------------------------------------------------------------------
function c77239126.adfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c77239126.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239126.adfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c77239126.adop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77239126.adfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end

