--青眼究极龙之墓(ZCG)
function c77239148.initial_effect(c)
    c:EnableReviveLimit()
	--Cannot Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239148,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetRange(LOCATION_HAND)
    e1:SetTargetRange(POS_FACEUP,1)
    e1:SetCondition(c77239148.spcon)
    e1:SetOperation(c77239148.spop)
    c:RegisterEffect(e1)
	
    --atklimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    c:RegisterEffect(e2)

    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    c:RegisterEffect(e3)
	
    --cannot release
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UNRELEASABLE_SUM)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e5)

    --battle indestructable
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
	
    --damage
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_DAMAGE)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_TO_GRAVE)
    e7:SetCondition(c77239148.damcon)
    e7:SetTarget(c77239148.damtg)
    e7:SetOperation(c77239148.damop)
    c:RegisterEffect(e7)

    --change battle target
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(77239148,1))
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e8:SetCode(EVENT_BE_BATTLE_TARGET)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(c77239148.cbcon)
    e8:SetTarget(c77239148.cbtg)
    e8:SetOperation(c77239148.cbop)
    c:RegisterEffect(e8)	
	
    --atkdown
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(77239148,0))
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e9:SetCategory(CATEGORY_ATKCHANGE)
    e9:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCountLimit(1)
    e9:SetCondition(c77239148.atkcon)
    e9:SetOperation(c77239148.atkop)
    c:RegisterEffect(e9)	
end
-------------------------------------------------------------------------------------
function c77239148.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
    and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function c77239148.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_MZONE,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
-------------------------------------------------------------------------------------
function c77239148.damcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function c77239148.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(3000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,3000)
end
function c77239148.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
-------------------------------------------------------------------------------------
function c77239148.cbcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bt=eg:GetFirst()
    return r~=REASON_REPLACE and c~=bt and bt:GetControler()==c:GetControler()
end
function c77239148.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetAttacker():GetAttackableTarget():IsContains(e:GetHandler()) end
end
function c77239148.cbop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and not Duel.GetAttacker():IsImmuneToEffect(e) then
        Duel.ChangeAttackTarget(c)
    end
end
-------------------------------------------------------------------------------------
function c77239148.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c77239148.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    e1:SetValue(-1000)
    c:RegisterEffect(e1)
end

