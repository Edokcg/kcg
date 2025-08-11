--奥利哈刚之神(ZCG)
function c77239230.initial_effect(c)
    c:EnableReviveLimit()
	
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.ritlimit)
    c:RegisterEffect(e1)
	
    --召唤不会被无效化
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)	
	
	--离场败北
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetOperation(c77239230.lose)
    c:RegisterEffect(e3)

    --效果免疫
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(c77239230.efilter)
    c:RegisterEffect(e4)

    --玩家不会受到战斗伤害
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(1,0)
    e5:SetValue(0)
    c:RegisterEffect(e5)

    --玩家不会受到效果伤害
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CHANGE_DAMAGE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(1,0)
    e6:SetValue(c77239230.damval)
    c:RegisterEffect(e6)
	
    --伤害
    local e7=Effect.CreateEffect(c)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e7:SetCategory(CATEGORY_DAMAGE)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EVENT_BATTLE_DESTROYING)
    e7:SetTarget(c77239230.tar)
    e7:SetCondition(c77239230.rdcon)
    e7:SetOperation(c77239230.rdop)
    c:RegisterEffect(e7)
	
    --不会被战斗破坏
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetValue(c77239230.indes)
    c:RegisterEffect(e8)	
end
---------------------------------------------------------------------------
function c77239230.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
---------------------------------------------------------------------------
function c77239230.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 then return 0 end
    return val
end
---------------------------------------------------------------------------
function c77239230.lose(e,tp,eg,ep,ev,re,r,rp)
    Duel.Win(1-tp,0x4)
end
---------------------------------------------------------------------------
function c77239230.indes(e,c) 
    return not c:IsAttribute(ATTRIBUTE_DEVINE)
end
---------------------------------------------------------------------------
function c77239230.rdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and e:GetHandler()==Duel.GetAttacker()
end
function c77239230.tar(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetAttackTarget()
    local X=a:GetAttack()*2+2000
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,1-tp,1,0,X)
end
function c77239230.rdop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttackTarget()
    local X=a:GetAttack()*2+2000
    Duel.Damage(1-tp,X,REASON_EFFECT)
end