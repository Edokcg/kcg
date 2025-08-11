--黒い魔術師・マハード
function c77239997.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239997,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77239997.spcon)
	e1:SetOperation(c77239997.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
	--Eraser
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239997,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c77239997.thtg)
	e4:SetOperation(c77239997.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e7)
	--immune
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(c77239997.efilter)
	c:RegisterEffect(e8)
	--[[atk/def
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_BASE_ATTACK)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(99999999)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_SET_BASE_DEFENSE)
	e10:SetValue(99999999)
	c:RegisterEffect(e10)]]
end
function c77239997.spfilter(c,Code)
	return c:IsCode(Code)
end
function c77239997.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c77239997.spfilter,tp,LOCATION_ONFIELD,0,1,nil,77239995) and Duel.IsExistingMatchingCard(c77239997.spfilter,tp,LOCATION_ONFIELD,0,1,nil,77239996)
end
function c77239997.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c77239997.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,77239995)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c77239997.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,77239996)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_RULE)
end
function c77239997.filter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c77239997.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239997.filter1,tp,LOCATION_GRAVE+LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c77239997.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77239997.filter1,tp,LOCATION_GRAVE+LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c77239997.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
