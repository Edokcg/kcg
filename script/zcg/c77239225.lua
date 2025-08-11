--奥利哈刚 赫克艾德斯(ZCG)
function c77239225.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239225.ctltg)
    e1:SetOperation(c77239225.ctlop)
    c:RegisterEffect(e1)
end
-------------------------------------------------------------------------------
function c77239225.ctltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c77239225.ctlop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetControl(c,1-tp) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EFFECT_CANNOT_SUMMON)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e2:SetTargetRange(1,0)
        c:RegisterEffect(e2)
    end
end