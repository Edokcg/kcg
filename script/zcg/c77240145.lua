--真红眼不死黑龙
function c77240145.initial_effect(c)
    c:SetUniqueOnField(1,0,77240145)
    --xyz summon
    Xyz.AddProcedure(c,nil,7,2)
    c:EnableReviveLimit()
	
    --immune spell
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77240145.efilter)
    c:RegisterEffect(e1)	
	
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77240145.reptg)
    c:RegisterEffect(e2)
	
    --atkup
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c77240145.val)
    c:RegisterEffect(e3)

    --spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c77240145.sptg)
	e4:SetOperation(c77240145.spop)
	c:RegisterEffect(e4)
end
----------------------------------------------------------------------
function c77240145.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
----------------------------------------------------------------------
function c77240145.val(e,c)
    return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE,0,nil,RACE_DRAGON)*600
end
----------------------------------------------------------------------
function c77240145.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReason(REASON_BATTLE) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectYesNo(tp,aux.Stringid(77631175,0)) then
        local c=e:GetHandler()
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        Duel.RaiseSingleEvent(c,EVENT_CUSTOM+77631175,e,0,0,0,0)
        return true
    else return false end
end
----------------------------------------------------------------------
function c77240145.filter(c,e,tp)
    return c:IsSetCard(0x3b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77240145.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77240145.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77240145.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end