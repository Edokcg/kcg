--奥利哈刚之圣都 亚特兰提斯(ZCG)
function c77239280.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)	
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77239280.tg)
    e1:SetOperation(c77239280.op)
    c:RegisterEffect(e1)    
	
	--
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e3)	
	
    --indes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetValue(1)
    c:RegisterEffect(e4)	
    local e5=e4:Clone()
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e5)	
	
    --must attack
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_FZONE)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetCode(EFFECT_MUST_ATTACK)
    c:RegisterEffect(e6)	

    --
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetRange(LOCATION_FZONE)	
    e7:SetCode(EFFECT_DIRECT_ATTACK)
    e7:SetTargetRange(LOCATION_MZONE,0)
    c:RegisterEffect(e7)

    --cannot disable
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_CANNOT_DISABLE)
    e8:SetRange(LOCATION_FZONE)
    c:RegisterEffect(e8)	
end
----------------------------------------------------------------------------
function c77239280.filter(c,e,tp)
    return c:IsSetCard(0xa50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239280.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c77239280.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED)
end
function c77239280.op(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239280.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,ft,ft,nil,e,tp)
    if g:GetCount()>0 then
        local fid=e:GetHandler():GetFieldID()
        local tc=g:GetFirst()
        while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local de=Effect.CreateEffect(e:GetHandler())
        de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        de:SetRange(LOCATION_MZONE)
        de:SetCode(EVENT_PHASE+PHASE_STANDBY)
        de:SetCountLimit(1)
        de:SetOperation(c77239280.desop)
        tc:RegisterEffect(de,true)
        Duel.SpecialSummonComplete()
        tc=g:GetNext()
        end
    end
end
function c77239280.desop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(1000)
    e:GetHandler():RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    e2:SetValue(1000)
    e:GetHandler():RegisterEffect(e2)	
end
----------------------------------------------------------------------------














