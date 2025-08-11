--真红眼黑铁枪
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --equip
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetTarget(s.eqtg)
    e2:SetOperation(s.eqop)
    c:RegisterEffect(e2)	
end
s.material_race=RACE_MACHINE
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc~=e:GetHandler() end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc then return end
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() then return end
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_EQUIP_LIMIT)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetValue(s.eqlimit)
    e0:SetLabelObject(tc)
    e0:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(1300)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c) 
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e2:SetRange(LOCATION_SZONE)  
    e2:SetCondition(s.atkcon)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2) 

end
function s.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    local tc=ec:GetBattleTarget()
    return ec and tc and tc:IsFaceup() and tc:IsControler(1-tp)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local ec=e:GetHandler():GetEquipTarget()
    local tc=ec:GetBattleTarget()
    if ec and tc and ec:IsFaceup() and tc:IsFaceup() then
        local val=tc:GetAttack()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(val)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
        ec:RegisterEffect(e1)
    end
end