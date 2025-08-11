--生与死的呼唤声(ZCG)
function c77239582.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTarget(c77239582.sptg)
    e1:SetOperation(c77239582.spop)
    c:RegisterEffect(e1)

    --destroy spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c77239582.spcon1)
    e3:SetOperation(c77239582.spop)
    c:RegisterEffect(e3)
end

function c77239582.filter1(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239582.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c77239582.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp,LOCATION_GRAVE)
end
function c77239582.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239582.filter1,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
    if g:GetCount()>0 then
        local fid=e:GetHandler():GetFieldID()
        local tc=g:GetFirst()
        while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(tc:GetAttack()*0.1)
        tc:RegisterEffect(e1,true)
        Duel.SpecialSummonComplete()
        tc=g:GetNext()
        end
    end
end

function c77239582.filter2(c,tp)
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
    and c:GetControler()==tp and c:IsLocation(LOCATION_GRAVE)
    and c:IsType(TYPE_MONSTER)
end
function c77239582.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239582.filter2,1,nil,tp)
end