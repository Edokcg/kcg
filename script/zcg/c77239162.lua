--超贪婪之壶(ZCG)
function c77239162.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c77239162.activate)	
    c:RegisterEffect(e1)
	
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c77239162.target)
    e2:SetOperation(c77239162.activate1)
    c:RegisterEffect(e2)
end
------------------------------------------------------------------
function c77239162.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetFlagEffect(tp,77239162)~=0 then return end
    Duel.RegisterFlagEffect(tp,77239162,0,0,0)
    c:SetTurnCounter(0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetOperation(c77239162.checkop)
    e1:SetCountLimit(1)
    Duel.RegisterEffect(e1,tp)
    c:RegisterFlagEffect(77239162,RESET_PHASE+PHASE_END,0,3)
    c77239162[c]=e1
end
function c77239162.checkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct==3 then
        Duel.Win(1-tp,0x30)
        c:ResetFlagEffect(77239162)
    end
end
------------------------------------------------------------------
function c77239162.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,4) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(4)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4)
end
function c77239162.activate1(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    Duel.Recover(tp,g:GetCount()*1000,REASON_EFFECT)	
end
