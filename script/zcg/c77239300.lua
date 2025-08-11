--殉道者 虚无大天使(ZCG)
function c77239300.initial_effect(c)
    c:EnableReviveLimit()
    --特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK)
    e1:SetCondition(c77239300.spcon)
    e1:SetTarget(c77239300.sptg)
    e1:SetOperation(c77239300.spop)
    c:RegisterEffect(e1)

    --怪兽效果无效
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetTarget(c77239300.disable)
    e4:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e4)	
	
	--跳过抽卡阶段
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)	
    e5:SetTargetRange(1,0)
    e5:SetCode(EFFECT_SKIP_DP)
    c:RegisterEffect(e5)
	
    --破坏抗性
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetCondition(c77239300.condition)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e7)	
	
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239300.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239300.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239300.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239300.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------------------
function c77239300.filter(c,tp)
    return  c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0xa60) and c:GetPreviousControler()==tp
end
function c77239300.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239300.filter,3,nil,tp)
end
function c77239300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239300.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
        c:CompleteProcedure()
    end
end
-----------------------------------------------------------------------------
function c77239300.disable(e,c)
    return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
-----------------------------------------------------------------------------
function c77239300.cfilter(c)
    return c:IsSetCard(0xa60)
end
function c77239300.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c77239300.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
-----------------------------------------------------------------------------
function c77239300.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239300.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239300.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
