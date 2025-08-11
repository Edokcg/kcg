--黑魔導女孩 紫将(ZCG)
function c77239956.initial_effect(c)
    --battle indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e1:SetCountLimit(1)
    e1:SetValue(c77239956.valcon)
    c:RegisterEffect(e1)
	
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239956,0))
    e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c77239956.target)
    e2:SetOperation(c77239956.activate)
    c:RegisterEffect(e2)
end
-----------------------------------------------------------------
function c77239956.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
-----------------------------------------------------------------
function c77239956.filter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove()
end
function c77239956.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c77239956.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239956.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c77239956.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77239956.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
        Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)       
    end
end
