--千年盘龙戟
function c77240087.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --remain field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e2)
	
    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c77240087.target)
    e3:SetOperation(c77240087.activate)
    c:RegisterEffect(e3)
end
----------------------------------------------------------------
function c77240087.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,h1) end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77240087.activate(e,tp,eg,ep,ev,re,r,rp)
    local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local ct=Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
    Duel.BreakEffect()
    Duel.Draw(tp,h1,REASON_EFFECT)
    Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
