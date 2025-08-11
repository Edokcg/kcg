--元素英雄-摩天大楼
function c77240144.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

    --act limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c77240144.aclimit)
    c:RegisterEffect(e2)
	
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_FZONE)	
    e3:SetTargetRange(1,0)
    e3:SetValue(1)
    c:RegisterEffect(e3)
	
    --Atk
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3008))
    e4:SetValue(1000)
    c:RegisterEffect(e4)

    --special summon
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCountLimit(1)
    e5:SetRange(LOCATION_FZONE)
    e5:SetTarget(c77240144.sptg)
    e5:SetOperation(c77240144.spop)
    c:RegisterEffect(e5)
end
----------------------------------------------------------------------
function c77240144.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
----------------------------------------------------------------------
function c77240144.filter(c,e,tp)
    return c:IsSetCard(0x3008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240144.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77240144.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77240144.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77240144.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end

