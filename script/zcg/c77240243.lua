--奥西里斯之兔女郎 （ZCG）
function c77240243.initial_effect(c)
  --control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240243,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c77240243.cttg)
	e1:SetOperation(c77240243.ctop)
	c:RegisterEffect(e1)
 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240243,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c77240243.sptg)
	e2:SetOperation(c77240243.spop)
	c:RegisterEffect(e2)
 --spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240243,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c77240243.sptg2)
	e3:SetOperation(c77240243.spop2)
	c:RegisterEffect(e3)

	--抗性
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(c77240243.efilter11)
    c:RegisterEffect(e11)
    --disable effect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_CHAIN_SOLVING)
    e12:SetRange(LOCATION_MZONE)
    e12:SetOperation(c77240243.disop12)
    c:RegisterEffect(e12)
    --disable
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_DISABLE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e13:SetTarget(c77240243.distg12)
    c:RegisterEffect(e13)
    --self destroy
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_SELF_DESTROY)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e14:SetTarget(c77240243.distg12)
    c:RegisterEffect(e14)
end
function c77240243.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)>0 end
end
function c77240243.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local sg=g:GetFirst()
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		sg=g:Select(tp,1,1,nil)
	end
	Duel.GetControl(sg,tp)
end
function c77240243.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c77240243.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE)  and chkc:IsControler(1-tp) and c77240243.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77240243.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77240243.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77240243.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
end
function c77240243.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240243.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240243.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77240243.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240243.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c77240243.efilter11(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77240243.disop12(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240243.distg12(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end