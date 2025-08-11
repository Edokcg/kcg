--太阳神的地狱翼神龙(ZCG)
function c77239925.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
    e1:SetCondition(c77239925.spcon)
    c:RegisterEffect(e1)
	
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)
	
	--攻击力
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(c77239925.value)
    c:RegisterEffect(e3)	
    local e9=e3:Clone()
    e9:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e9)	
	
    --不能解放
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
	
    --破坏
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_CHAIN_SOLVING)
    e6:SetOperation(c77239925.disop)
    c:RegisterEffect(e6)	

    --不能破坏
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e7:SetValue(1)
    c:RegisterEffect(e7)
    local e8=e7:Clone()
    e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e8)	
end
------------------------------------------------------------------------------------
function c77239925.spfilter(c)
    return c:IsAttribute(ATTRIBUTE_DIVINE)
end
function c77239925.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
Duel.IsExistingMatchingCard(c77239925.spfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
------------------------------------------------------------------------------------
function c77239925.value(e,c)
    return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD)*1000	
end
------------------------------------------------------------------------------------
function c77239925.disop(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then return end
    local rc=re:GetHandler()
    if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
        Duel.Destroy(rc,REASON_EFFECT)
    end
end


