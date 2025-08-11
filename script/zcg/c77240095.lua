--狂战士
function c77240095.initial_effect(c)
    --flip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(40267580,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e1:SetTarget(c77240095.eqtg)
    e1:SetOperation(c77240095.eqop)
    c:RegisterEffect(e1)
	
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(40267580,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)	
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c77240095.con)
    e2:SetOperation(c77240095.atkop)
    c:RegisterEffect(e2)	
end
--------------------------------------------------------------------------
function c77240095.filter(c)
    return c:IsFaceup()
end
function c77240095.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c77240095.filter(chkc) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c77240095.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77240095.eqlimit(e,c)
    return e:GetOwner()==c
end
function c77240095.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc and not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsFaceup() and c:IsRelateToEffect(e) then
        if tc:IsFaceup() and tc:IsRelateToEffect(e) then
            Duel.Equip(tp,c,tc)
            --Add Equip limit
            local e1=Effect.CreateEffect(tc)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c77240095.eqlimit)
            c:RegisterEffect(e1)            
        else
            Duel.SendtoGrave(c,REASON_EFFECT)
        end
    end
end
--------------------------------------------------------------------------
function c77240095.con(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c77240095.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local ec=c:GetEquipTarget()
    local atk=ec:GetAttack()/2	
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-atk)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    ec:RegisterEffect(e1)
    Duel.Damage(1-tp,atk,REASON_EFFECT)	
end


