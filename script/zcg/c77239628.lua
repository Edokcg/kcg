--植物的愤怒 南瓜蛛
function c77239628.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239628,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77239628.target)
    e1:SetOperation(c77239628.operation)
    c:RegisterEffect(e1)
	
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(TIMING_DAMAGE_STEP)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239628.atkcon)
    e2:SetCost(c77239628.atkcost)
    e2:SetOperation(c77239628.atkop)
    c:RegisterEffect(e2)
end
------------------------------------------------------------------
function c77239628.filter(c)
    return c:IsCode(77240146) and c:IsAbleToHand()
end
function c77239628.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239628.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239628.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239628.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
------------------------------------------------------------------
function c77239628.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=Duel.GetAttackTarget()
    if not c then return false end
    if c:IsControler(1-tp) then c=Duel.GetAttacker() end
    e:SetLabelObject(c)
    return c and c:IsSetCard(0xa90) and c:IsRelateToBattle()
end
function c77239628.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77239628.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetLabelObject()
    if c:IsFaceup() and c:IsRelateToBattle() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(1500)
        c:RegisterEffect(e1)
    end
end


