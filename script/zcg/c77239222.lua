--奥利哈刚 刻拉多斯(ZCG)
function c77239222.initial_effect(c)
	--def
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_SET_DEFENSE)
    e1:SetCondition(c77239222.descon)	
    e1:SetValue(0)
    c:RegisterEffect(e1)
	
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetCondition(c77239222.descon)	
    e2:SetValue(2000)
    c:RegisterEffect(e2)

    --变防御
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c77239222.poscon)
    e3:SetOperation(c77239222.posop)
    c:RegisterEffect(e3)	
end
--------------------------------------------------------------------------------------
function c77239222.filter(c)
    return c:IsFaceup() and (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
function c77239222.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c77239222.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
--------------------------------------------------------------------------------------
function c77239222.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetAttackedCount()>0
end
function c77239222.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
    c:RegisterEffect(e1)
end
