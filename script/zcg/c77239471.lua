--千年禁忌-爱西丝之斧(ZCG)
function c77239471.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    --remain field
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e1)
	
    --disable effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetOperation(c77239471.disop2)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(0xa,0xa)
    e3:SetTarget(c77239471.distg2)
    c:RegisterEffect(e3)
    --self destroy
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(0xa,0xa)
    e4:SetTarget(c77239471.distg2)
    c:RegisterEffect(e4)
	
	--
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_CONTROL)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)	
    e5:SetRange(LOCATION_SZONE)	
    e5:SetCountLimit(1)
    e5:SetTarget(c77239471.target)
    e5:SetOperation(c77239471.activate)
    c:RegisterEffect(e5)	
end
-------------------------------------------------------------------------
function c77239471.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77239471.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:GetCardTarget():IsContains(e:GetHandler())
end
-------------------------------------------------------------------------
function c77239471.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c77239471.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp)
    end
end


