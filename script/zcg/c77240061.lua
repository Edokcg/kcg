--机甲天龙 炎翅双刀龙
function c77240061.initial_effect(c)

	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77240061.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c77240061.spcon)
	e2:SetOperation(c77240061.spop)
	c:RegisterEffect(e2)

	--disable effect
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c77240061.disop2)
    c:RegisterEffect(e3)
    --disable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_DISABLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0xa,0xa)
    e4:SetTarget(c77240061.distg2)
    c:RegisterEffect(e4)
    --self destroy
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_SELF_DESTROY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0xa,0xa)
    e5:SetTarget(c77240061.distg2)
    c:RegisterEffect(e5)

    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(c77240061.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0,1)
    e53:SetTarget(c77240061.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0,1)
    e54:SetTarget(c77240061.distg2)
    c:RegisterEffect(e54)
end

function c77240061.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77240061.spfilter1(c,tp,fc)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
end
function c77240061.spfilter2(c,fc)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToGraveAsCost()
end
function c77240061.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	and Duel.IsExistingMatchingCard(c77240061.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
	and Duel.IsExistingMatchingCard(c77240061.spfilter2,tp,0,LOCATION_MZONE,1,nil,tp,c)
end
function c77240061.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c77240061.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c77240061.spfilter2,tp,0,LOCATION_MZONE,1,1,nil,tp,c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
-----------------------------------------------------------------------
function c77240061.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsControler(1-tp) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240061.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
        and c:GetCardTarget():IsContains(e:GetHandler())
end