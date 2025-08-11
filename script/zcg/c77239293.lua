--奥利哈刚之魂
function c77239293.initial_effect(c)
    c:EnableReviveLimit()

    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetValue(77239230)
	c:RegisterEffect(e0)

    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
    e1:SetCondition(c77239293.spcon)
    e1:SetOperation(c77239293.spop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetCondition(c77239293.condition)
    e2:SetOperation(c77239293.operation)
    c:RegisterEffect(e2)

	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(1,0)
    e3:SetCode(EFFECT_SKIP_DP)
    c:RegisterEffect(e3)

    --disable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetTarget(c77239293.disable)
    e4:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e4)	
	
	--
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e5:SetCondition(c77239293.indcon)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e6)

    --
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
    e7:SetCode(EVENT_SPSUMMON_SUCCESS)
    e7:SetOperation(c77239293.op)
    c:RegisterEffect(e7)

    --伤害
    local e8=Effect.CreateEffect(c)
    e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e8:SetCategory(CATEGORY_DAMAGE)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EVENT_BATTLE_DESTROYING)
    e8:SetTarget(c77239293.tar)
    e8:SetCondition(c77239293.rdcon)
    e8:SetOperation(c77239293.rdop)
    c:RegisterEffect(e8)
end
------------------------------------------------------------------------
function c77239293.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
        and Duel.CheckReleaseGroup(c:GetControler(),c77239293.cfilter,1,nil)
end
function c77239293.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(c:GetControler(),c77239293.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetValue(77239230)
    c:RegisterEffect(e1)
	c:CopyEffect(77239230,RESET_EVENT+0x1fe0000)
end
------------------------------------------------------------------------
function c77239293.cfilter(c)
    return c:IsCode(77239230) or c:IsCode(123108)
end
function c77239293.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239293.cfilter,1,nil)
end
function c77239293.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.SelectYesNo(tp,aux.Stringid(77239293,0)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
		e:GetHandler():CompleteProcedure()
		local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(77239230)
        c:RegisterEffect(e1)	
	    c:CopyEffect(77239230,RESET_EVENT+0x1fe0000)
    end
end
------------------------------------------------------------------------
function c77239293.disable(e,c)
    return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
------------------------------------------------------------------------
function c77239293.indcon(e)
    return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_DECK,0,1,nil,TYPE_MONSTER)
end

function c77239293.op(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():CopyEffect(77239230,1)
end

function c77239293.rdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and e:GetHandler()==Duel.GetAttacker()
end
function c77239293.tar(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetAttackTarget()
    local X=a:GetAttack()*2+2000
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,1-tp,1,0,X)
end
function c77239293.rdop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttackTarget()
    local X=a:GetAttack()*2+2000
    Duel.Damage(1-tp,X,REASON_EFFECT)
end