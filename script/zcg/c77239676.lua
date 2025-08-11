--黑暗大法师(ZCG)
function c77239676.initial_effect(c)
    c:EnableReviveLimit()	
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)	
	
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCondition(c77239676.condition)
    e2:SetTarget(c77239676.target)
    e2:SetOperation(c77239676.activate)
    c:RegisterEffect(e2)
	
    local e3=Effect.CreateEffect(c)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)	
    e3:SetType(EFFECT_TYPE_SINGLE)	
    e3:SetRange(LOCATION_MZONE)	
    e3:SetCode(EFFECT_SET_ATTACK_FINAL)
    e3:SetCondition(c77239676.con)	
    e3:SetValue(2147483647)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
    e4:SetValue(2147483647)
    c:RegisterEffect(e4)	
end
------------------------------------------------------------------------------
function c77239676.con(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
------------------------------------------------------------------------------
function c77239676.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker()==e:GetHandler()
end
function c77239676.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239676.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_RULE)
        local sum=g:GetSum(Card.GetAttack)
        Duel.Damage(1-tp,sum,REASON_EFFECT)
	    local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
