--海马的仪式
function c77239135.initial_effect(c)
    c:EnableReviveLimit()
	
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239135.spcon)
    e1:SetOperation(c77239135.spop)
    c:RegisterEffect(e1)	

    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239135,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)	
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77239135.target)
    e2:SetOperation(c77239135.activate)
    c:RegisterEffect(e2)

    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c77239135.target1)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(c77239135.target1)
    e4:SetValue(1)
    c:RegisterEffect(e4)	
end
----------------------------------------------------------------
function c77239135.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.CheckLPCost(c:GetControler(),600)
end
function c77239135.spop(e,tp,eg,ep,ev,re,r,rp,c)
      local c=e:GetHandler()
    Duel.PayLPCost(tp,600)   
end
----------------------------------------------------------------
function c77239135.filter(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239135.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0     
        and Duel.IsExistingMatchingCard(c77239135.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c77239135.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    if ft>3 then ft=3 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239135.filter,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
    if g:GetCount()>0 then
	    local tc=g:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		    local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1,true)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2,true)
	        Duel.SpecialSummonComplete()
            tc=g:GetNext()	
		end
    end
end
----------------------------------------------------------------
function c77239135.target1(e,c)
    return c:IsSetCard(0xdd)
end



