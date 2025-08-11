--邪神·太阳神之翼神龙
function c77239933.initial_effect(c)
    c:EnableReviveLimit()
	
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c77239933.val)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
	
    --unaffectable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(c77239933.efilter)
    c:RegisterEffect(e4)
	
	--One Turn Kill
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(77239933,0))
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)	
    e6:SetCost(c77239933.atkcost)
    e6:SetOperation(c77239933.atkop)
    c:RegisterEffect(e6)
	
    --destroy
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77239933,1))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c77239933.descost)
    e7:SetTarget(c77239933.destg)
    e7:SetOperation(c77239933.desop)
    c:RegisterEffect(e7)	
end
-------------------------------------------------------------------
function c77239933.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
-------------------------------------------------------------------
function c77239933.val(e,c)
    local g=Duel.GetMatchingGroup(c77239933.vfilter,c:GetControler(),LOCATION_REMOVED,0,c)
    return g:GetSum(Card.GetAttack)+1000
end
function c77239933.vfilter(c)
    return c:IsCode(10000000) or c:IsCode(10000010) or c:IsCode(10000020)
	 or c:IsCode(513000134) or c:IsCode(513000135) or c:IsCode(513000136)
end
-------------------------------------------------------------------
function c77239933.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLP(tp)>1 end
    local lp=Duel.GetLP(tp)
    e:SetLabel(lp-1)
    Duel.PayLPCost(tp,lp-1)
end
function c77239933.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
    end
end
-------------------------------------------------------------------
function c77239933.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function c77239933.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239933.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)	
    e1:SetValue(1)	
    c:RegisterEffect(e1)	
end




