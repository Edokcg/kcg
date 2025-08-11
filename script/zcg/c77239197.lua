--仪式的魔法场地(ZCG)
function c77239197.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetValue(2000)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
	
    --atk up
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetCondition(c77239197.atkcon)
    e4:SetTarget(c77239197.atktg)
    e4:SetValue(c77239197.atkval)
    c:RegisterEffect(e4)

    --Activate
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_CONTROL)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCountLimit(1)	
    e5:SetTarget(c77239197.target)
    e5:SetOperation(c77239197.activate)
    c:RegisterEffect(e5)	
end
---------------------------------------------------------------------------------------
function c77239197.atkcon(e)
    c77239197[0]=false
    return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c77239197.atktg(e,c)
    return c==Duel.GetAttacker()
end
function c77239197.atkval(e,c)
    local d=Duel.GetAttackTarget()
    if c77239197[0] or c:GetAttack()<d:GetAttack() then
        c77239197[0]=true
        return 2000
    else return 0 end
end
---------------------------------------------------------------------------------------
function c77239197.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c77239197.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp)
    end
end
