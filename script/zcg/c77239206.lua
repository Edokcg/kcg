--奥利哈刚 巴龙(ZCG)
function c77239206.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetCondition(aux.bdocon)
    e1:SetOperation(c77239206.atop)
    c:RegisterEffect(e1)  
    
    --send to grave
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetCondition(c77239206.sgcon)
    e2:SetTarget(c77239206.sgtg)
    e2:SetOperation(c77239206.sgop)
    c:RegisterEffect(e2)
    
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetOperation(c77239206.negop1)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BE_BATTLE_TARGET)
    e4:SetOperation(c77239206.negop2)
    c:RegisterEffect(e4)
	
    --special summon
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_SPSUMMON_PROC)
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e5:SetRange(LOCATION_HAND)
    e5:SetCondition(c77239206.spcon)
    c:RegisterEffect(e5)
end
-----------------------------------------------------------------------
function c77239206.negop1(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if d~=nil then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        d:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        d:RegisterEffect(e2)
    end
end
function c77239206.negop2(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    if a~=nil then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        a:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        a:RegisterEffect(e2)
    end
end
-----------------------------------------------------------------------
function c77239206.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
    end
end
-----------------------------------------------------------------------
function c77239206.sgcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetAttack()
    e:SetLabel(atk)
    return c:IsPreviousPosition(POS_FACEUP)
end
function c77239206.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local atk=math.floor(e:GetLabel()/700)
    if chkc then return chkc:GetControler()~=tp and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToGrave() end
    if chk==0 then return atk>0 and Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,atk,atk,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c77239206.sgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    Duel.SendtoGrave(sg,REASON_EFFECT)
end
-----------------------------------------------------------------------
function c77239206.spcon(e,c)
    if c==nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
