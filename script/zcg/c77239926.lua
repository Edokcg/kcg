 --地狱之神不死鸟
function c77239926.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239926.spcon)
    c:RegisterEffect(e1)
	
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)

    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(c77239926.activate)	
    c:RegisterEffect(e3)	
	
    --atk/def
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(c77239926.adval)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e7)	
	
    --direct attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e4)	

    --Damage
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c77239926.damtg)
    e5:SetOperation(c77239926.damop)
    c:RegisterEffect(e5)

    --to grave
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(77239926,0))
    e8:SetCategory(CATEGORY_TOGRAVE)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1)
    e8:SetCode(EVENT_PHASE+PHASE_END)
    e8:SetCondition(c77239926.tgcon)
    e8:SetTarget(c77239926.tgtg)
    e8:SetOperation(c77239926.tgop)
    c:RegisterEffect(e8)	
end
----------------------------------------------------------------------
function c77239926.spfilter(c)
    return c:IsCode(10000010)
end
function c77239926.spfilter1(c)
    return c:IsCode(83764718)
end
function c77239926.spcon(e,c)
    if c==nil then return true end
    if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
    local g=Duel.GetMatchingGroupCount(c77239926.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
    local g1=Duel.GetMatchingGroupCount(c77239926.spfilter1,c:GetControler(),LOCATION_GRAVE,0,nil)
    return g>0 and g1>0
end
----------------------------------------------------------------------
function c77239926.activate(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,1)
    Duel.RegisterEffect(e1,tp)
end
----------------------------------------------------------------------
function c77239926.adval(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE)*1000
end
----------------------------------------------------------------------
function c77239926.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(e:GetHandler():GetAttack())
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetAttack())
end
function c77239926.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
----------------------------------------------------------------------
function c77239926.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c77239926.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c77239926.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.SendtoGrave(c,REASON_EFFECT)
    end
end

