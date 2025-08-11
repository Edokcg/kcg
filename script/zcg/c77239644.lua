--植物的愤怒 古树逢春(ZCG)
function c77239644.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --[[disable effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_FZONE)
    e2:SetOperation(c77239644.disop)
    c:RegisterEffect(e2)]]

    --negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c77239644.discon)
	e2:SetTarget(c77239644.distg)
	e2:SetOperation(c77239644.disop)
	c:RegisterEffect(e2)

    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(77239644)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    c:RegisterEffect(e3)
	
    --cannot disable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_DISABLE)
    e4:SetRange(LOCATION_FZONE)
    e4:SetValue(0)
    c:RegisterEffect(e4)
	
	--
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239644,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_FZONE)	
    e5:SetCondition(c77239644.condition)	
    e5:SetTarget(c77239644.target)
    e5:SetOperation(c77239644.activate)
    c:RegisterEffect(e5)
end	
---------------------------------------------------------------------------
--[[function c77239644.cfilter2(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xa90) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) 

end
function c77239644.disop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsExists(c77239644.cfilter,1,nil,tp) then
            Duel.NegateEffect(ev)
        end
    end
end]]
function c77239644.cfilter1(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0xa90)
end
function c77239644.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c77239644.cfilter1,1,nil) and Duel.IsChainNegatable(ev)
end
function c77239644.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77239644.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

---------------------------------------------------------------------------
function c77239644.cfilter(c)
    return c:IsFaceup() and c:IsCode(77239621)
end
function c77239644.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c77239644.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c77239644.filter(c,e,tp)
    return c:IsCode(77239605) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239644.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c77239644.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c77239644.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239644.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end


