--黑魔导女孩 玛古
function c77239962.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239962,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77239962.eqcon)
    e1:SetTarget(c77239962.eqtg)
    e1:SetOperation(c77239962.eqop)
    c:RegisterEffect(e1)
    --[[equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239962,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239962.eqtg)
    e1:SetOperation(c77239962.eqop)
    c:RegisterEffect(e1)

    --eqlimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c77239962.eqlimit)
    c:RegisterEffect(e2)
    
    --Atk up
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(1500)
    e3:SetCondition(aux.IsUnionState)
    c:RegisterEffect(e3)]]
    
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239962,1)) 
    e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE) 
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCost(c77239962.cost)
    --e2:SetCondition(aux.IsUnionState)
    e2:SetTarget(c77239962.target)
    e2:SetOperation(c77239962.operation)
    c:RegisterEffect(e2)
    
    --sendtohand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239962,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    --e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239962.spcost)
    e3:SetTarget(c77239962.sptg)
    e3:SetOperation(c77239962.spop)
    c:RegisterEffect(e3)
end
------------------------------------------------------------------
function c77239962.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():CheckUniqueOnField(tp)
end
function c77239962.spfilter(c)
    return c:IsFaceup()
end
function c77239962.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239962.spfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c77239962.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239962.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c77239962.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e1:SetValue(c77239962.eqlimit)
    e1:SetLabelObject(tc)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(1500)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e2)
end
function c77239962.eqlimit(e,c)
    return c==e:GetLabelObject()
end
--[[function c77239962.eqlimit(e,c)
    return c:IsFaceup()
end
function c77239962.filter(c)
    return c:IsFaceup()
end
function c77239962.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239962.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c77239962.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c77239962.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77239962.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c77239962.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end]]
------------------------------------------------------------------
function c77239962.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77239962.filter1(c)
    return c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)
end
function c77239962.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239962.filter1,tp,0,LOCATION_SZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(c77239962.filter1,tp,0,LOCATION_SZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239962.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239962.filter1,tp,0,LOCATION_SZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
------------------------------------------------------------------
function c77239962.costfilter(c)
    return c:IsDiscardable()
end
function c77239962.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239962.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,c77239962.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c77239962.filter(c,e,tp)
    return c:IsSetCard(0x30a2) and c:IsAbleToHand()
end
function c77239962.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239962.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c77239962.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239962.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
    end
end


