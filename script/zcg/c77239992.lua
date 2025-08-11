--黑魔导 LV6
function c77239992.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)	
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)	
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(c77239992.sptg)
    e1:SetOperation(c77239992.spop)
    c:RegisterEffect(e1)

    --must attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_MUST_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_EP)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(0,1)
    c:RegisterEffect(e4)
    --cannot select battle target
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,LOCATION_MZONE)
    e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e5:SetCondition(c77239992.dircon)	
    e5:SetValue(c77239992.atlimit)
    c:RegisterEffect(e5)	
	
	--
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TODECK)	
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetTarget(c77239992.thtg)
    e6:SetOperation(c77239992.thop)
    c:RegisterEffect(e6)		
end
-----------------------------------------------------------------
function c77239992.filter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost() 
end
function c77239992.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c77239992.filter,tp,LOCATION_GRAVE,0,6,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239992.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239992.filter,tp,LOCATION_GRAVE,0,6,6,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)	
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    local sum=0
    local tc=g:GetFirst()
    while tc do
        local def=tc:GetDefense()
        sum=sum+def
        tc=g:GetNext()
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_DEFENSE)
    e1:SetValue(sum)
    e1:SetReset(RESET_EVENT+0xff0000)
    c:RegisterEffect(e1)	
end
-----------------------------------------------------------------
function c77239992.cfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c77239992.dircon(e)
    return Duel.IsExistingMatchingCard(c77239992.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end
-----------------------------------------------------------------
function c77239992.atlimit(e,c)
    return c~=e:GetHandler()
end
-----------------------------------------------------------------
function c77239992.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c77239992.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end


