--毁灭的大法师
function c77239677.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239677,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetRange(LOCATION_HAND)
    e1:SetTargetRange(POS_FACEUP,1)
    e1:SetCondition(c77239677.spcon)
    e1:SetOperation(c77239677.spop)
    c:RegisterEffect(e1)
	
    --cannot attack
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
	
    --cannot be target
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(c77239677.afilter)
    c:RegisterEffect(e6)

	--
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCondition(c77239677.damcon)
    e7:SetOperation(c77239677.damop)
    c:RegisterEffect(e7)	
end
------------------------------------------------------------------
function c77239677.filter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost()
end
function c77239677.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239677.filter,c:GetControler(),LOCATION_HAND,0,3,e:GetHandler())
end
function c77239677.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239677.filter,tp,LOCATION_HAND,0,3,3,c)
    Duel.SendtoGrave(g,REASON_COST)
end
---------------------------------------------------------------------
function c77239677.afilter(e,re)
    return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end
----------------------------------------------------------------------
function c77239677.damcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239677.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(tp,Duel.GetLP(tp)/2)
end

