--奥利哈刚的元素(ZCG)
function c77239248.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Cost Change
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_LPCOST_CHANGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(1,0)
    e2:SetValue(c77239248.costchange)
    c:RegisterEffect(e2)
	
    --攻击力
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetValue(c77239248.val)
    c:RegisterEffect(e3) 

    --选择
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c77239248.mtcon)
    e4:SetOperation(c77239248.activate)
    c:RegisterEffect(e4)

    --回手卡
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetTarget(c77239248.target)
    e5:SetOperation(c77239248.operation)
    c:RegisterEffect(e5)	
end
----------------------------------------------------------------------------
function c77239248.costchange(e,re,rp,val)
    if re and re:GetHandler():IsType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER) and not re:GetHandler():IsCode(9236985) then
        return 0
    else
        return val
    end
end
----------------------------------------------------------------------------
function c77239248.val(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)*500
end
----------------------------------------------------------------------------
function c77239248.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp
end
function c77239248.activate(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    local g2=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
    local opt=0
    if g1:GetCount()>0 and g2:GetCount()>2 then
        opt=Duel.SelectOption(1-tp,aux.Stringid(77239248,1),aux.Stringid(77239248,0))
    elseif g1:GetCount()>0 then
        opt=Duel.SelectOption(1-tp,aux.Stringid(77239248,1))
    elseif g2:GetCount()>2 then
        opt=Duel.SelectOption(1-tp,aux.Stringid(77239248,0))+1
    else return end
    if opt==0 then
        Duel.Destroy(g1,REASON_EFFECT)
    else
        local dg=g2:RandomSelect(1-tp,3)
        Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)		
    end
end
----------------------------------------------------------------------------
function c77239248.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c77239248.operation(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)==1 then
        Duel.ConfirmCards(1-tp,e:GetHandler())
    end
end