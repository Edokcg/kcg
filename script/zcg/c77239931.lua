--邪神·奥西里斯之天空龙
function c77239931.initial_effect(c)
    c:EnableReviveLimit() 
	
    --unaffectable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(c77239931.efilter)
    c:RegisterEffect(e4)

    --atk
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetValue(c77239931.val)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e7)
    --[[atk/def
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(c77239931.adval)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e7)]]
	
    --atkdown
    local e8=Effect.CreateEffect(c)
    e8:SetCategory(CATEGORY_ATKCHANGE)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EVENT_SUMMON_SUCCESS)
    e8:SetCondition(c77239931.atkcon)
    e8:SetTarget(c77239931.atktg)
    e8:SetOperation(c77239931.atkop)
    c:RegisterEffect(e8)
    local e9=e8:Clone()
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e9)
    local e10=e9:Clone()
    e10:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e10)	
end
------------------------------------------------------------------
function c77239931.val(e,c)
    local g=Duel.GetMatchingGroup(c77239931.vfilter,c:GetControler(),LOCATION_REMOVED,0,c)
    return g:GetSum(Card.GetAttack)+1000
end
function c77239931.vfilter(c)
    return c:IsCode(10000000) or c:IsCode(10000010) or c:IsCode(10000020)
	or c:IsCode(513000134) or c:IsCode(513000135) or c:IsCode(513000136)
end
--[[function c77239931.adval(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*1000+1000
end]]
------------------------------------------------------------------
function c77239931.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
------------------------------------------------------------------
function c77239931.atkfilter(c,e,tp)
    return c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c77239931.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239931.atkfilter,1,nil,nil,1-tp)
end
function c77239931.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
    Duel.SetTargetCard(eg)
end
function c77239931.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c77239931.atkfilter,nil,e,1-tp)
    local dg=Group.CreateGroup()
    local c=e:GetHandler()
    local tc=g:GetFirst()
    while tc do
        local preatk=tc:GetAttack()
        local predef=tc:GetDefense()         
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-2000)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(-2000)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        if (preatk~=0 and tc:GetAttack()==0) or (predef~=0 and tc:GetDefense()==0) then
           dg:AddCard(tc)
        end
        tc=g:GetNext()
    end
    Duel.Destroy(dg,REASON_EFFECT)
end




