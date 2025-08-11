--女子佣兵 高音(ZCG)
function c77239522.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK)
    e1:SetCondition(c77239522.spcon)
    c:RegisterEffect(e1)
	
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)	
	
    --
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_HANDES)	
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(c77239522.target)
    e3:SetOperation(c77239522.activate)
    c:RegisterEffect(e3)	
end
-----------------------------------------------------
function c77239522.filter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c77239522.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,nil,77239523)==1
		and Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,nil,77239524)==1
end
-----------------------------------------------------
function c77239522.filter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c77239522.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239522.filter,tp,LOCATION_HAND,0,1,nil) end
    local sg=Duel.GetMatchingGroup(c77239522.filter,tp,LOCATION_HAND,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,sg:GetCount(),0,0)
end
function c77239522.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sg=Duel.GetMatchingGroup(c77239522.filter,tp,LOCATION_HAND,0,nil)
    local ct=Duel.DiscardHand(tp,c77239522.filter,sg:GetCount(),sg:GetCount(),REASON_EFFECT+REASON_DISCARD)
    if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
        --multi attack
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(ct)
        c:RegisterEffect(e1)
    end	
end

