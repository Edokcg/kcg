--邪心教义-悲
function c77239019.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --除外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239019,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c77239019.tgcon)
	e2:SetTarget(c77239019.tgtg)
	e2:SetOperation(c77239019.tgop)
	c:RegisterEffect(e2)

	
	--除外
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c77239019.bantg)
	e3:SetOperation(c77239019.banop)
	c:RegisterEffect(e3)	
end
----------------------------------------------
function c77239019.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_GRAVE)
end
function c77239019.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239019.cfilter,1,nil,tp)
end
function c77239019.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(c77239019.cfilter,nil,tp)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c77239019.tgop(e,tp,eg,ep,ev,re,r,rp)
    local ct=eg:FilterCount(c77239019.cfilter,nil,tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if g:GetCount()>=ct then
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,ct,ct,nil)
		Duel.HintSelection(g2)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	end
end
----------------------------------------------------------------------
function c77239019.filter(c)
	return c:IsCode(77239019) and c:IsAbleToRemove()
end
function c77239019.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77239019.filter,tp,LOCATION_GRAVE,0,e:GetHandler(),e:GetHandler():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c77239019.banop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239019.filter,tp,LOCATION_GRAVE,0,e:GetHandler(),e:GetHandler():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
