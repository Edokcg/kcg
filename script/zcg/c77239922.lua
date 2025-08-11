--神之怒(ZCG)
function c77239922.initial_effect(c)
	c:EnableReviveLimit()
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e1)
	
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239922,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(c77239922.destg)
    e2:SetOperation(c77239922.desop)
    c:RegisterEffect(e2)
	
    --actlimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,1)
    e3:SetValue(c77239922.aclimit)
    c:RegisterEffect(e3)	
	
    --cannot set
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_MSET)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)	
    e4:SetTargetRange(0,1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_CANNOT_TURN_SET)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e7)	
end
--------------------------------------------------------------------------------------
function c77239922.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239922.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
--------------------------------------------------------------------------------------
function c77239922.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end

