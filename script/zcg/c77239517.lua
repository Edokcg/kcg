--女子佣兵 光辉师
function c77239517.initial_effect(c)
    --token
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239517,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77239517.sptg)
    e1:SetOperation(c77239517.spop)
    c:RegisterEffect(e1)

    --token
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239517,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c77239517.rmcost)	
    e2:SetCondition(c77239517.spcon1)
    e2:SetTarget(c77239517.sptg1)
    e2:SetOperation(c77239517.spop1)
    c:RegisterEffect(e2)	
end
-----------------------------------------------------------------
function c77239517.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c77239517.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,77239539,0x1111,0x1111,0,0,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
        local token=Duel.CreateToken(tp,77239539)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end
-----------------------------------------------------------------
function c77239517.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1,true)
end
function c77239517.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239517.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c77239517.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,77239539,0x1111,0x1111,0,0,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
        local token=Duel.CreateToken(tp,77239539)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		if Duel.GetMatchingGroupCount(c77239517.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)>=2 then
            local dam=e:GetHandler():GetAttack()        
            Duel.Damage(1-tp,dam*2,REASON_EFFECT)		    
		end
    end
end
function c77239517.atkfilter(c)
    return c:IsFaceup() and c:IsCode(77239539)
end

