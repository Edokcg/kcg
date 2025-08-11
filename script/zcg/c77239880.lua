--加速之不动星尘
function c77239880.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239880.cost)	
    e1:SetTarget(c77239880.target)
    e1:SetOperation(c77239880.activate)
    c:RegisterEffect(e1)
	
    --recover
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239880,0))
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c77239880.condition)
    e2:SetTarget(c77239880.target1)
    e2:SetOperation(c77239880.operation)
    c:RegisterEffect(e2)

    --send replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e3:SetCondition(c77239880.repcon)
    e3:SetOperation(c77239880.repop)
    c:RegisterEffect(e3)	
end
function c77239880.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetActivityCount(1-tp,ACTIVITY_SUMMON)==0
        and Duel.GetActivityCount(tp,ACTIVITY_FLIPSUMMON)==0 and Duel.GetActivityCount(1-tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(0,1)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetTargetRange(1,0)
    Duel.RegisterEffect(e2,tp)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    Duel.RegisterEffect(e3,tp)
end
function c77239880.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
        Duel.IsPlayerCanSpecialSummonMonster(tp,77239880,0,0x21,3000,3000,8,RACE_DRAGON,ATTRIBUTE_WIND) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239880.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,77239880,0,0x21,3000,3000,8,RACE_DRAGON,ATTRIBUTE_WIND) then return end
    c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL)
    Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP_ATTACK)
end
---------------------------------------------------------------------
function c77239880.condition(e,tp,eg,ep,ev,re,r,rp)
    return 1-tp==Duel.GetTurnPlayer()
end
function c77239880.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c77239880.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
---------------------------------------------------------------------
function c77239880.repcon(e)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c77239880.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.SSet(tp,c)
	Duel.ChangePosition(c,POS_FACEDOWN)
    Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
