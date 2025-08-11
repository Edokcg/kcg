--传说骑士 提玛欧斯(ZCG)
function c77240202.initial_effect(c)
    c:EnableReviveLimit()
    --cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77240202.efilter)
	c:RegisterEffect(e1)

    --summon success
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c77240202.sumsuc)
    c:RegisterEffect(e2)

    --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c77240202.cost)
	e3:SetTarget(c77240202.tar)
	e3:SetOperation(c77240202.op)
	c:RegisterEffect(e3)

    --sendcard
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(c77240202.activate)
	c:RegisterEffect(e4)
end

function c77240202.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_SPELL) and re:GetHandler():IsControler(1-(e:GetHandler():GetOwner()))
end

function c77240202.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(c77240202.distg)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c77240202.disop)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetTargetRange(0,1)
    e3:SetValue(c77240202.aclimit)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e3,tp)
end

function c77240202.distg(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_SPELL)
end

function c77240202.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_SPELL) then
		Duel.NegateEffect(ev)
	end
end

function c77240202.aclimit(e,re,tp)
    return re:GetHandler():IsType(TYPE_SPELL) and not re:GetHandler():IsImmuneToEffect(e)
end

function c77240202.cfilter1(c)
    return c:IsCode(77240202) and c:IsAbleToGraveAsCost()
end

function c77240202.cfilter2(c)
    return c:IsCode(77240203) and c:IsAbleToGraveAsCost()
end

function c77240202.cfilter3(c)
    return c:IsCode(77240204) and c:IsAbleToGraveAsCost()
end

function c77240202.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240202.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c77240202.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c77240202.cfilter3,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,c77240202.cfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,c77240202.cfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g3=Duel.SelectMatchingCard(tp,c77240202.cfilter3,tp,LOCATION_ONFIELD,0,1,1,nil)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.Release(g1,REASON_EFFECT)
end

function c77240202.filter(c,e,tp)
	return c:IsCode(77239495) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c77240202.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240202.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c77240202.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240202.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end

function c77240202.desfilter(c,rc)
    return c:IsType(TYPE_SPELL)
end

function c77240202.activate(e,tp,eg,ep,ev,re,r,rp,c)
    local tg=Duel.SelectMatchingCard(tp,c77240202.desfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SendtoHand(tg,tp,REASON_EFFECT)
end