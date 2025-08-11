--地狱之神炎皇 乌利亚(ZCG)
function c77239895.initial_effect(c)
    c:EnableReviveLimit()
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77239895.val)
    c:RegisterEffect(e1)

    --Negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239895,1))
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c77239895.codisable)
    e2:SetTarget(c77239895.tgdisable)
    e2:SetOperation(c77239895.opdisable)
    c:RegisterEffect(e2)
	
    --Negate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239895,2))
    e3:SetCategory(CATEGORY_NEGATE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239895.cost)	
    e3:SetCondition(c77239895.codisable1)
    e3:SetTarget(c77239895.tgdisable1)
    e3:SetOperation(c77239895.opdisable1)
    c:RegisterEffect(e3)	
end
-----------------------------------------------------------------------------------------
function c77239895.val(e,c)
    return Duel.GetMatchingGroupCount(c77239895.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*1000
end
function c77239895.filter(c)
    return c:IsType(TYPE_TRAP)
end
---------------------------------------------------------------------------------------
function c77239895.codisable(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp~=tp 
        and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c77239895.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(77239895)==0 end
    if c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
        c:RegisterFlagEffect(77239895,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
    end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c77239895.opdisable(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() or c:GetAttack()< 500 or not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
        return
    end
    if Duel.NegateActivation(ev) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-500)
        c:RegisterEffect(e1)
    end
end
---------------------------------------------------------------------------------------
function c77239895.cfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c77239895.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239895.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239895.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77239895.codisable1(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_MONSTER) and rp~=tp 
        and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c77239895.tgdisable1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
    end
end
function c77239895.opdisable1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.GetControl(eg,tp)
    end
end

