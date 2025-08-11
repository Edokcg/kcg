--斯洛蜘女
function c77240106.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18063928,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77240106.target)
    e1:SetOperation(c77240106.activate)
    c:RegisterEffect(e1)
end
function c77240106.filter(c)
    return c:IsDefensePos()
end
function c77240106.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240106.filter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c77240106.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,g:GetCount(),0,0)
end
function c77240106.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77240106.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(g:GetCount()*500)
        e:GetHandler():RegisterEffect(e1)
    end
end
