--黑暗大法师埋葬殉道之灵(ZCG)
function c77239679.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239679,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCondition(c77239679.spcon)
    e2:SetTarget(c77239679.sumtg)
    e2:SetOperation(c77239679.sumop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --Activate
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCode(EVENT_CHAIN_SOLVING)
    e5:SetCondition(c77239679.condition)
    e5:SetTarget(c77239679.sumtg)
    e5:SetOperation(c77239679.sumop)
    c:RegisterEffect(e5)
	
    --win
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetOperation(c77239679.winop)
    c:RegisterEffect(e6)

    --cannot disable
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_CANNOT_DISABLE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(0)
    c:RegisterEffect(e7)

    --indes
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e8:SetValue(1)
    c:RegisterEffect(e8)
    local e9=e8:Clone()
    e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e9)

	--search
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(77239679,0))
    e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e10:SetCode(EVENT_TO_GRAVE)
    e10:SetCondition(c77239679.condition1)
    e10:SetTarget(c77239679.target)
    e10:SetOperation(c77239679.operation)
    c:RegisterEffect(e10)
end
----------------------------------------------------------------------------------------
function c77239679.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=eg:GetFirst()
    return ec:IsSetCard(0xa60) and rp~=tp
end
function c77239679.condition(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler():IsSetCard(0xa60) and rp~=tp
end
function c77239679.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c77239679.sumop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)
	    e:GetHandler():CompleteProcedure()	
    end
end
----------------------------------------------------------------------------------------
function c77239679.winop(e,tp,eg,ep,ev,re,r,rp)
    local WIN_REASON_EXODIA = 0x10
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g:GetCount()>=2  then
        Duel.Win(tp,WIN_REASON_EXODIA)
    end
end
----------------------------------------------------------------------------------------
function c77239679.condition1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function c77239679.filter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c77239679.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239679.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239679.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239679.filter,tp,LOCATION_DECK,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=sg:Select(tp,1,1,nil)
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
end

