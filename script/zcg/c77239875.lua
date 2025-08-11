--盗贼王
function c77239875.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c77239875.target)
    e2:SetOperation(c77239875.activate)
    c:RegisterEffect(e2)
end
function c77239875.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c77239875.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
    if g:GetCount()>0 then
        Duel.ConfirmCards(p,g)
        Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
        local sg=g:Select(p,1,1,nil)
        Duel.SendtoHand(sg,tp,REASON_EFFECT)
        Duel.ShuffleHand(1-p)
    end
end