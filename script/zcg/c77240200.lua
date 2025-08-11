--究极的邪神(ZCG)
function c77240200.initial_effect(c)
    c:EnableReviveLimit()
    c:EnableCounterPermit(0xa11)

    --spsummon success
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c77240200.addct)
	e1:SetOperation(c77240200.addc)
	c:RegisterEffect(e1)

    --unaffectable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(c77240200.efilter)
    c:RegisterEffect(e2)

    --battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)

    --CopyEffect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetOperation(c77240200.op)
    c:RegisterEffect(e4)

    --damage
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77240200,0))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCost(c77240200.cost)
    e5:SetOperation(c77240200.op1)
    c:RegisterEffect(e5)

    --destroy
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(77240200,1))
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCost(c77240200.cost)
    e6:SetOperation(c77240200.op2)
    c:RegisterEffect(e6)

    --spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77240200,2))
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c77240200.cost)
	e7:SetTarget(c77240200.tar)
	e7:SetOperation(c77240200.op3)
	c:RegisterEffect(e7)
end

function c77240200.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0xa11)
end

function c77240200.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xa11,3)
	end
end

function c77240200.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end

function c77240200.op(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():CopyEffect(77239931,1)
    e:GetHandler():CopyEffect(77239932,1)
    e:GetHandler():CopyEffect(77239933,1)
end

function c77240200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xa11,1,REASON_COST)
end

function c77240200.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,4000,REASON_EFFECT)
end

function c77240200.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end

function c77240200.filter(c,e,tp)
	return (c:IsCode(77239931) or c:IsCode(77239932) or c:IsCode(77239933)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c77240200.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240200.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end

function c77240200.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240200.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,99,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
        tc=g:GetNext()
	end
end