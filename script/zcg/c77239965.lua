--天空龙黑魔導女孩(ZCG)
function c77239965.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239965.spcon)
    e1:SetOperation(c77239965.spop)
    c:RegisterEffect(e1)

    --攻防上升
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e2:SetTarget(c77239965.target)
    e2:SetValue(1000)
    c:RegisterEffect(e2)

    --cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)

    --atk
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c77239965.atkcon)
	e4:SetTarget(c77239965.atktg)
	e4:SetOperation(c77239965.atkop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
    e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e6)

    --direct attack
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77239965,0))
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetCountLimit(1)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c77239965.cost)
    e7:SetOperation(c77239965.datop)
    c:RegisterEffect(e7)

    --spsummon
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77239965,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(c77239965.sptg)
	e8:SetOperation(c77239965.spop1)
	c:RegisterEffect(e8)
end

function c77239965.tlimit(c)
    return c:IsType(TYPE_MONSTER)
end
function c77239965.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
        and Duel.CheckReleaseGroup(c:GetControler(),c77239965.tlimit,3,nil)
end
function c77239965.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(c:GetControler(),c77239965.tlimit,3,3,nil)
    Duel.Release(g,REASON_COST)
end
function c77239965.target(e,c)
	return c:IsRace(RACE_SPELLCASTER)
end

function c77239965.atkfilter(c,e,tp)
	return c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c77239965.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77239965.atkfilter,1,nil,nil,1-tp)
end
function c77239965.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function c77239965.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c77239965.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetAttack()<=2000 then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end

function c77239965.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function c77239965.datop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DIRECT_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end

function c77239965.SPfilter(c,e,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c77239965.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77239965.SPfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77239965.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239965.SPfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end