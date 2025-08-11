--奥西里斯之光魔杖宙斯
function c77239720.initial_effect(c)
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77239720.reccon)
    e1:SetOperation(c77239720.recop)
    c:RegisterEffect(e1)
    local e3=e1:Clone()
    e3:SetCode(EVENT_MSET)
    c:RegisterEffect(e3)
	
    --抗性
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(c77239720.efilter11)
    c:RegisterEffect(e11)
    --disable effect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_CHAIN_SOLVING)
    e12:SetRange(LOCATION_MZONE)
    e12:SetOperation(c77239720.disop12)
    c:RegisterEffect(e12)
    --disable
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_DISABLE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e13:SetTarget(c77239720.distg12)
    c:RegisterEffect(e13)
    --self destroy
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_SELF_DESTROY)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e14:SetTarget(c77239720.distg12)
    c:RegisterEffect(e14)
end
-------------------------------------------------------------------
function c77239720.cfilter(c,tp)
	return c:GetSummonPlayer()==tp --and c:GetSummonType()==SUMMON_TYPE_ADVANCE
end
function c77239720.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77239720.cfilter,1,nil,tp)
end
function c77239720.recop(e,tp,eg,ep,ev,re,r,rp)
    local cc=0
    local tc=eg:GetFirst():GetMaterial()
    local m=tc:GetFirst()
    while m do
         cc=cc+m:GetAttack()
         m=tc:GetNext()
    end
	Duel.Hint(HINT_CARD,0,77239720)
	Duel.Recover(tp,cc,REASON_EFFECT)
end
---------------------------------------------------------------------------------
function c77239720.efilter11(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77239720.disop12(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77239720.distg12(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end


