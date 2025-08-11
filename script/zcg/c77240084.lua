--千年番天印
function c77240084.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --remain field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e2)
	
    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_CONTROL)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)	
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)	
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c77240084.con)	
    e3:SetTarget(c77240084.target)
    e3:SetOperation(c77240084.activate)
    c:RegisterEffect(e3)	
end
-----------------------------------------------------------------
function c77240084.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77240084.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c77240084.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
    end
end

