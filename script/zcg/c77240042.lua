--不死之黑魔术师
function c77240042.initial_effect(c)
    
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(900000080,2))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCost(c77240042.actcost)
    e1:SetCondition(c77240042.spcon)
    e1:SetTarget(c77240042.sptg)
    e1:SetOperation(c77240042.spop)
    c:RegisterEffect(e1)
end
-----------------------------------------------------------------
function c77240042.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetFlagEffect(tp,48179391)==0 end
    Duel.RegisterFlagEffect(tp,48179391,0,0,0)
end
function c77240042.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c77240042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77240042.spop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end
