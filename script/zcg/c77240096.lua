--女鬼阴爪
function c77240096.initial_effect(c)
    --turn set
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(3510565,0))
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77240096.target)
    e1:SetOperation(c77240096.operation)
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(3510565,1))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    e2:SetTarget(c77240096.damtg)
    e2:SetOperation(c77240096.damop)
    c:RegisterEffect(e2)
	
    --battle indestructable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)	
end
function c77240096.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(3510565)==0 end
    c:RegisterFlagEffect(3510565,RESET_EVENT+RESETS_STANDARD+RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c77240096.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
    end
end
function c77240096.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c77240096.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
