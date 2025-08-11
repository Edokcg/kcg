--黑魔导女孩 LV3(ZCG)
function c77240195.initial_effect(c)
    --direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)

    --指示物
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_DAMAGE)
    e2:SetOperation(c77240195.operation)
    c:RegisterEffect(e2)

    --cannot be target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e3:SetCondition(c77240195.tgcon)
    e3:SetValue(aux.imval1)
    c:RegisterEffect(e3)

    --release
    local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c77240195.cost)
	e4:SetTarget(c77240195.tar)
	e4:SetOperation(c77240195.op)
	c:RegisterEffect(e4)
end

function c77240195.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(500)
    e:GetHandler():RegisterEffect(e1)
end

function c77240195.damfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x10a2)
end

function c77240195.tgcon(e)
    return Duel.IsExistingMatchingCard(c77240195.damfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end

function c77240195.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

function c77240195.filter(c,e,tp)
	return c:IsCode(77240196) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240195.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240195.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c77240195.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240195.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()   
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end