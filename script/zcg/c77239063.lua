--黑暗大法师(ZCG)
function c77239063.initial_effect(c)
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
    e2:SetCondition(c77239063.condition)
    e2:SetTarget(c77239063.target)
    e2:SetOperation(c77239063.activate)
    c:RegisterEffect(e2)
	
    local e3=Effect.CreateEffect(c)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)	
    e3:SetType(EFFECT_TYPE_SINGLE)	
    e3:SetRange(LOCATION_MZONE)	
    e3:SetCode(EFFECT_SET_ATTACK_FINAL)
    e3:SetCondition(c77239063.con)	
    e3:SetValue(2147483647)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
    e4:SetValue(2147483647)
    c:RegisterEffect(e4)	
	
    --win
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCode(EVENT_TO_HAND)
    e5:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED)
    e5:SetCondition(c77239063.spcon)
    e5:SetOperation(c77239063.operation)
    --c:RegisterEffect(e5)	
end
------------------------------------------------------------------------------
function c77239063.con(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
------------------------------------------------------------------------------
function c77239063.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker()==e:GetHandler()
end
function c77239063.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239063.activate(e,tp,eg,ep,ev,re,r,rp)
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


function c77239063.check(g)
    local a1=false
    local a2=false
    local a3=false
    local a4=false
    local a5=false
    local tc=g:GetFirst()
    while tc do
        local code=tc:GetCode()
        if code==8124921 then a1=true
        elseif code==44519536 then a2=true
        elseif code==70903634 then a3=true
        elseif code==7902349 then a4=true
        elseif code==33396948 then a5=true
        end
        tc=g:GetNext()
    end
    return a1 and a2 and a3 and a4 and a5
end
function c77239063.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandler():GetControler()
    return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,8124921)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,44519536) 
    and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,70903634) 
    and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,7902349)
    and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,33396948)		
end
function c77239063.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()	
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local wtp=c77239063.check(g)
	if wtp then
        local g1=Duel.SelectReleaseGroupEx(tp,Card.IsCode,1,1,nil,8124921)
        local g2=Duel.SelectReleaseGroupEx(tp,Card.IsCode,1,1,nil,44519536)
        local g3=Duel.SelectReleaseGroupEx(tp,Card.IsCode,1,1,nil,70903634)
        local g4=Duel.SelectReleaseGroupEx(tp,Card.IsCode,1,1,nil,7902349)
        local g5=Duel.SelectReleaseGroupEx(tp,Card.IsCode,1,1,nil,33396948)
        g1:Merge(g2)
        g1:Merge(g3)
        g1:Merge(g4)
        g1:Merge(g5)
        Duel.Release(g1,POS_FACEDOWN,REASON_COST)
        Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
    end		
end
