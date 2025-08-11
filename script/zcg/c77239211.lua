--奥利哈刚 灵魂操控者
function c77239211.initial_effect(c)
    --turn set
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239211,0))
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239211.target)
    e1:SetOperation(c77239211.operation)
    c:RegisterEffect(e1)
	
    --flip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239211,0))
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetTarget(c77239211.target1)
    e2:SetOperation(c77239211.operation1)
    c:RegisterEffect(e2)		
end
-----------------------------------------------------------------------
function c77239211.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(77239211)==0 end
    c:RegisterFlagEffect(77239211,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c77239211.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
    end
end
-----------------------------------------------------------------------
function c77239211.filter(c)
    return c:IsFaceup()
end
function c77239211.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c77239211.filter(chkc) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c77239211.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c77239211.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)	
    local g=Duel.SelectMatchingCard(tp,c77239211.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)	
    local tc1=g:GetFirst()   
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
        Duel.RegisterEffect(e1,tp)
		Duel.CalculateDamage(tc,tc1)
    end
end

