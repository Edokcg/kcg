--千年宝莲灯(ZCG)
function c77239490.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c77239490.con)	
    e2:SetOperation(c77239490.drop)
    c:RegisterEffect(e2)
	
    --remain field
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e3)	
end
function c77239490.con(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)<4
end
function c77239490.drop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_DRAW_COUNT)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_DRAW)
    e1:SetValue(Duel.GetDrawCount(tp)+2)
    Duel.RegisterEffect(e1,tp)
end