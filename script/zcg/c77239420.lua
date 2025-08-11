--六芒星 龙骑士(ZCG)
function c77239420.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239420.spcon)
    e1:SetOperation(c77239420.spop)	
    c:RegisterEffect(e1)
	
    --不会被战斗破坏
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)	
end
-------------------------------------------------------------------
function c77239420.spcon(e,c)
    if c==nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
end
function c77239420.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)	
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(-1400)
    e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)	
    e2:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
    e2:SetRange(LOCATION_MZONE)	
    e2:SetValue(-1250)
    c:RegisterEffect(e2)
end
-------------------------------------------------------------------
