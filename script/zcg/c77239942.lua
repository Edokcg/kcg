--沉默的太阳神翼神龙 LV0(ZCG)
function c77239942.initial_effect(c)
    --抽卡
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_DRAW)
    e1:SetOperation(c77239942.atkop)
    c:RegisterEffect(e1)

    --战斗伤害为0
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetValue(1)
    c:RegisterEffect(e2)

    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)	
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetTarget(c77239942.sptg)
    e3:SetOperation(c77239942.spop)
    c:RegisterEffect(e3)
end
-----------------------------------------------------------------
function c77239942.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(500)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    e2:SetValue(500)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_LEVEL)
    e3:SetValue(1)
    e3:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e3)	
end
-----------------------------------------------------------------
--[[function c77239942.filter(c,e,tp)
    return c:IsCode(777777777777777777) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239942.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239942.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77239942.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239942.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    local tc=g:GetFirst()   
   if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
        tc:CompleteProcedure()		
    end
end]]

function c77239942.filter(c,e,tp)
    return c:IsCode(77239945) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239942.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77239942.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c77239942.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239942.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    local tc=g:GetFirst()   
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    end
end