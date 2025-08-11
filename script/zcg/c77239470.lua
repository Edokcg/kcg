--千年禁忌-夏达之锤(ZCG)
function c77239470.initial_effect(c)
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
    e2:SetOperation(c77239470.disop2)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(0xa,0xa)
    e3:SetTarget(c77239470.distg2)
    c:RegisterEffect(e3)
    --self destroy
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(0xa,0xa)
    e4:SetTarget(c77239470.distg2)
    c:RegisterEffect(e4)
	
	--
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c77239470.target)
    e5:SetOperation(c77239470.activate)
    c:RegisterEffect(e5)	
end
-------------------------------------------------------------------------
function c77239470.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77239470.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:GetCardTarget():IsContains(e:GetHandler())
end
-------------------------------------------------------------------------
function c77239470.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    if chk==0 then return h>0 and Duel.IsPlayerCanDraw(tp,h) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(h)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,h)
end
function c77239470.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
    Duel.BreakEffect()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end


