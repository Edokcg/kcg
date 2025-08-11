--殉道者 断援兽
function c77240155.initial_effect(c)
    --control
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77240155.ctlcon)
    e1:SetTarget(c77240155.ctltg)
    e1:SetOperation(c77240155.ctlop)
    c:RegisterEffect(e1)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240155.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240155.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240155.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77240155.disop)
    c:RegisterEffect(e13)
end
function c77240155.cfilter(c)
    return c:IsSetCard(0xa60) and c:IsType(TYPE_MONSTER)
end
function c77240155.ctlcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(c77240155.cfilter,tp,LOCATION_MZONE,0,e:GetHandler())>0
end
function c77240155.ctltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end--and Duel.IsExistingMatchingCard(c77240155.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c77240155.ctlop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetControl(c,1-tp) then
	--disable spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_MSET)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    c:RegisterEffect(e4)
    end
end

function c77240155.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240155.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240155.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end