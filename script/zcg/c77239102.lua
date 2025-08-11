--翼神龙的召唤之雏(Z)
function c77239102.initial_effect(c)
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c77239102.sptg)
	e1:SetOperation(c77239102.spop)
	c:RegisterEffect(e1)
	
    --效果免疫
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c77239102.efilter)
    c:RegisterEffect(e2)
end
---------------------------------------------------------------
function c77239102.filter(c,e,tp)
	return (c:IsCode(10000010) or c:IsCode(513000134)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c77239102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239102.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c77239102.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77239102.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
    	e1:SetCategory(CATEGORY_TOHAND)
 	    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	    e1:SetCode(EVENT_PHASE+PHASE_END)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetCountLimit(1)		
	    e1:SetTarget(c77239102.rettg)
	    e1:SetOperation(c77239102.retop)
	    c:RegisterEffect(e1)		
	end
end
function c77239102.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c77239102.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    Duel.SendtoHand(c,nil,2,REASON_EFFECT)
end
---------------------------------------------------------------
function c77239102.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
